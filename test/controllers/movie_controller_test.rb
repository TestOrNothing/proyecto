# frozen_string_literal: true

require 'test_helper'

class MovieControllerTest < ActionDispatch::IntegrationTest
  def setup
    @movie = Movie.new(title: 'matrix', image: nil, restricted: false)
    @movie2 = Movie.create(title: 'matrix 2', image: nil, restricted: false)
    @movie3 = Movie.create(title: 'matrix 3', image: nil, restricted: true)
    @time1 = MovieTime.create(room: 5, date_start: Date.new(2000, 10, 10),
                              date_end: Date.new(2000, 11, 12), time: 'TANDA',
                              movie_id: @movie2.id, location: 'Santiago', lenguage: 'Ingles')
    @time2 = MovieTime.create(room: 6, date_start: Date.new(2000, 10, 10),
                              date_end: Date.new(2000, 11, 12), time: 'TANDA',
                              movie_id: @movie3.id, location: 'Santiago', lenguage: 'Ingles')
    @time3 = MovieTime.create(room: 6, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2021, 11, 12), time: 'TANDA',
                              movie_id: @movie3.id, location: 'Santiago', lenguage: 'Ingles')
  end

  def teardown
    MovieTime.destroy_all
    Movie.destroy_all
  end

  test 'should get new' do
    get movie_new_url
    assert_response :success
  end

  test 'should create movie' do
    assert_difference 'Movie.count' do
      post movie_new_url,
           params: { title: 'matrix 4', image: nil }
    end
  end

  test "should't create  movie" do
    assert_no_difference 'Movie.count' do
      post movie_new_url,
           params: { title: nil, image: nil }
    end
  end

  test 'should redirect whitout creating a movie' do
    post movie_new_url,
         params: { title: nil, image: nil }
    assert_redirected_to movie_new_url
  end

  test 'should redirect creating a movie' do
    post movie_new_url,
         params: { title: 'matrix 4', image: nil }
    assert_redirected_to movie_new_url
  end

  test 'create_movie_time failure' do
    post '/movie_time/new',
         params: { movie_time: { room: 5, date_start: Date.new(2000, 10, 10),
                                 date_end: Date.new(2000, 11, 12), time: 'TANDA',
                                 movie_id: @movie2.id } }
    assert_redirected_to '/movie/new'
  end

  test 'create_movie_time succes' do
    post '/movie_time/new',
         params: { movie_time: { room: 2, date_start: Date.new(2000, 10, 10),
                                 date_end: Date.new(2000, 11, 12), time: 'TANDA',
                                 movie_id: @movie2.id } }
    assert_redirected_to '/movie/new'
  end

  test 'create_movie_time failure occupied notice' do
    post '/movie_time/new',
         params: { movie_time: { room: 5, date_start: Date.new(2000, 10, 10),
                                 date_end: Date.new(2000, 11, 12), time: 'TANDA',
                                 movie_id: @movie2.id } }
    message = "La sala esta ocupada entre #{Date.new(2000, 10, 10)} y el #{Date.new(2000, 11, 12)}"
    assert_equal message, flash[:notice][:room][0]
  end

  test 'create_movie_time failure date_start notice' do
    post '/movie_time/new',
         params: { movie_time: { room: 5, date_start: Date.new(2001, 10, 10),
                                 date_end: Date.new(2000, 11, 12), time: 'TANDA',
                                 movie_id: @movie2.id } }
    assert_equal 'El día de inicio tiene que ser antes o igual al día de termino',
                 flash[:notice][:date_start][0]
  end

  test 'create_movie_time succes notice' do
    post '/movie_time/new',
         params: { movie_time: { room: 2, date_start: Date.new(2000, 10, 10),
                                 date_end: Date.new(2000, 11, 12), time: 'TANDA',
                                 movie_id: @movie2.id, location: 'Santiago', lenguage: 'Ingles' } }
    assert_equal 'Pelicula asignada con exito', flash[:notice]
  end

  test 'list_by_dates Mayor de edad' do
    get '/movies/list?date=2020-11-12&age=Mayor+de+edad&idioma=Ingles&place=Santiago&commit=Buscar'
    assert_equal true, (response.parsed_body.include? 'Solo apta para mayores de edad')
    assert_response :success
  end

  test 'list_by_dates Menor de edad' do
    get '/movies/list?date=2000-11-12&age=Menor+de+edad&idioma=Ingles&place=Santiago&commit=Buscar'
    assert_response :success
    assert_equal false, (response.parsed_body.include? 'Solo apta para mayores de edad')
  end
end
