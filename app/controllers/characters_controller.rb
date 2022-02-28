# frozen_string_literal: true

class CharactersController < ApplicationController
  before_action :authenticate_user!

  def index
    @characters = Rack::Reducer.call(params, dataset: Character.all, filters: [
                                       ->(name:) { where('lower(name) like ?', name.downcase) },
                                       ->(age:) { where(age: age) },
                                       ->(movie:) { where(program: Program.find(movie)) }
                                     ])
    render json: @characters
  end

  def show
    @character = Character.find_by(name: params[:name])

    render status: :ok, json: {
      character: {
        name: @character.name,
        image: @character.image
      }
    }
  end

  def create
    @character = Character.new(character_params)

    @character.save ? success_character_created : error_character_save
  end

  def update
    @character = Character.find(params[:id])

    success_character_updated if @character.update(character_params)
  end

  def destroy
    @character = Character.find(params[:id])

    success_character_destroyed if @character.destroy
  end

  private

  def success_character_created
    render status: :created, json: @character
  end

  def success_character_destroyed
    render status: :ok, json: { message: 'Character deleted' }
  end

  def success_character_updated
    render status: :ok, json: @character
  end

  def error_character_save
    render status: :unprocessable_entity, json: { errors: @character.errors.full_messages }
  end

  def character_params
    params.require(:character).permit(
      :name, :age, :weight, :history, :image
    )
  end
end
