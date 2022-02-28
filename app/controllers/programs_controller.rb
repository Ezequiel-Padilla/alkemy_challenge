# frozen_string_literal: true

class ProgramsController < ApplicationController
  before_action :authenticate_user!

  def index
    @programs = Rack::Reducer.call(params, dataset: Program.all, filters: [
                                     ->(title:) { where('lower(title) like ?', title.downcase) },
                                     ->(genre:) { where(genre: genre) },
                                     ->(order:) { order(order.to_sym) }
                                   ])

    index_respond_with(@programs)
  end

  def show
    @program = Program.find(params[:id])

    render status: :ok, json: {
      program: @program,
      characters: @program.characters
    }
  end

  def create
    @program = Program.new(program_params)
    @program.save ? success_program_created : error_program_save
  end

  def update
    @program = Program.find(params[:id])
    success_program_updated if @program.update(program_params)
  end

  def destroy
    @program = Program.find(params[:id])
    success_program_destroyed if @program.destroy
  end

  private

  def index_respond_with(_programs)
    render json: @programs do |program|
      program.as_json.merge(
        title: program.title,
        image: program.image,
        created_at: program.created_at
      )
    end
  end

  def success_program_created
    render status: :created, json: @program
  end

  def success_program_updated
    render status: :ok, json: @program
  end

  def success_program_destroyed
    render status: :ok, json: { message: 'Program deleted' }
  end

  def error_program_save
    render status: :unprocessable_entity, json: { errors: @program.errors.full_messages }
  end

  def program_params
    params.require(:program).permit(
      :title, :rating, :image, :genre
    )
  end
end
