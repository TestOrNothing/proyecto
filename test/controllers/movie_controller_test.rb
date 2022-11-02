# frozen_string_literal: true

require 'test_helper'

class MovieControllerTest < ActionDispatch::IntegrationTest
  def setup
    @movie = Movie.new(title: 'matrix', image: nil)
    @movie2 = Movie.create(title: 'matrix 2', image: nil)
    @time1 = MovieTime.create(room: 5, date_start: Date.new(2000, 10, 10),
                              date_end: Date.new(2000, 11, 12), time: 'TANDA',
                              movie_id: @movie2.id)
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
      params: { movie_time: {room: 5, date_start: Date.new(2000, 10, 10),
      date_end: Date.new(2000, 11, 12), time: 'TANDA',
      movie_id: @movie2.id}}
    assert_redirected_to '/movie/new'
  end

  test 'create_movie_time succes' do 
    post '/movie_time/new', 
      params: { movie_time: {room: 2, date_start: Date.new(2000, 10, 10),
      date_end: Date.new(2000, 11, 12), time: 'TANDA',
      movie_id: @movie2.id}}
    assert_redirected_to '/movie/new'
  end

  test 'create_movie_time failure occupied notice' do 
    post '/movie_time/new', 
      params: { movie_time: {room: 5, date_start: Date.new(2000, 10, 10),
      date_end: Date.new(2000, 11, 12), time: 'TANDA',
      movie_id: @movie2.id}}
    assert_equal "La sala esta ocupada entre #{Date.new(2000, 10, 10)} y el #{Date.new(2000, 11, 12)}", flash[:notice][:room][0]
  end

  test 'create_movie_time failure date_start notice' do 
    post '/movie_time/new', 
      params: { movie_time: {room: 5, date_start: Date.new(2001, 10, 10),
      date_end: Date.new(2000, 11, 12), time: 'TANDA',
      movie_id: @movie2.id}}
    assert_equal 'El día de inicio tiene que ser antes o igual al día de termino', flash[:notice][:date_start][0]
  end

  test 'create_movie_time succes notice' do 
    post '/movie_time/new', 
      params: { movie_time: {room: 2, date_start: Date.new(2000, 10, 10),
      date_end: Date.new(2000, 11, 12), time: 'TANDA',
      movie_id: @movie2.id}}
      assert_equal 'Pelicula asignada con exito', flash[:notice]
  end

  test 'list_by_dates' do 
    get '/movies/list'
    assert_response :success
  end
end
