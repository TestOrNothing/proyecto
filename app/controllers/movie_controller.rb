# frozen_string_literal: true

# Controler that manages all actions related to movie creation, room assignment and movie schedule
class MovieController < ApplicationController
  def home; end

  def new
    @movie_times = MovieTime.new
  end

  def post
    title = params[:title]
    image = params[:image]
    restricted = params[:restricted]
    restricted = restricted != '0'
    Rails.logger.debug restricted
    Rails.logger.debug 'the restricted imput is above'
    @movie = Movie.new(title:, image:, restricted:)
    if @movie.save
      Rails.logger.debug @movie.restricted
      redirect_to '/movie/new', notice: 'Pelicula creada con exito'
    else
      redirect_to '/movie/new', notice: @movie.errors.messages
    end
  end

  def create_movie_time
    movie_time_params = params.require(:movie_time).permit(:movie_id, :time, :date_start,
                                                           :date_end, :room, :location, :lenguage)
    movie_time = MovieTime.create(movie_time_params)
    if movie_time.persisted?
      redirect_to '/movie/new', notice: 'Pelicula asignada con exito'
    else
      redirect_to '/movie/new', notice: movie_time.errors.messages
    end
  end

  def list_by_date
    @date = params[:date]
    @age = params[:age]
    @lenguage = params[:idioma]
    @location = params[:place]
    @filter = if @age == 'Menor de edad'
                Movie.where(restricted: false).includes(:movie_times).where(
                  ['movie_times.date_start <= ? and ? <= movie_times.date_end and movie_times.location = ?',
                   @date, @date, @location]
                ).references(:movie_times)
              else
                Movie.includes(:movie_times).where(
                  ['movie_times.date_start <= ? and ? <= movie_times.date_end and movie_times.location = ?',
                   @date, @date, @location]
                ).references(:movie_times)
              end
    [@filter, @lenguage]
  end
end
