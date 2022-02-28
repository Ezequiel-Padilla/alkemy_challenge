# frozen_string_literal: true

class GenresController < ApplicationController
  before_action :authenticate_user!

  def index
    @genres = Genre.all

    render json: @genres
  end

  def show
    @genre = Genre.find(params[:id])

    render json: @genre
  end

  def create
    @genre = Genre.new(genre_params)
    @genre.save ? success_genre_created : error_genre_save
  end

  def update
    @genre = Genre.find(params[:id])
    success_genre_updated if @genre.update(genre_params)
  end

  def destroy
    @genre = Genre.find(params[:id])
    success_genre_destroyed if @genre.destroy
  end

  private

  def success_genre_created
    render status: :created, json: @genre
  end

  def success_genre_updated
    render status: :ok, json: @genre
  end

  def success_genre_destroyed
    render status: :ok, json: { message: 'Genre deleted' }
  end

  def error_genre_save
    render status: :unprocessable_entity, json: { errors: @genre.errors.full_messages }
  end

  def genre_params
    params.require(:genre).permit(
      :name, :image
    )
  end
end
