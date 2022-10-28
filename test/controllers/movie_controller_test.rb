# frozen_string_literal: true

require 'test_helper'

class MovieControllerTest < ActionDispatch::IntegrationTest
  def setup
    @movie = Movie.new(title: "matrix", image: nil)
    @movie2 = Movie.create(title: "matrix 2", image: nil )
    @time1 = MovieTime.create(room: 5, date_start: Date.new(2000, 10, 10),
          date_end: Date.new(2000, 11, 12), time: 'TANDA',
          movie_id: @movie2.id)
    @time2 = MovieTime.create(room: 4, date_start: Date.new(2000, 10, 10),
          date_end: Date.new(2000, 11, 12), time: 'TANDA',
          movie_id: @movie2.id)
    @time3 = MovieTime.create(room: 3, date_start: Date.new(2000, 10, 10),
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
        params: {title: "matrix 4", image: nil}
    end
  end

  test "should't create  movie" do 
    assert_no_difference 'Movie.count' do 
      post movie_new_url,
        params: {title: nil, image: nil}
    end
  end

  test "should redirect whitout creating a movie" do 
    post movie_new_url,
      params: {title: nil, image: nil}
    assert_redirected_to movie_new_url()
  end

  test "should redirect creating a movie" do 
    post movie_new_url,
      params: {title: "matrix 4", image: nil}
    assert_redirected_to movie_new_url()
  end

  test "create movie_time" do 
  end

  test "list by date" do 
    filter = Movie.includes(:movie_times).where(['movie_times.date_start <= ? and
      ? <= movie_times.date_end',
      Date.new(2000, 10, 10), Date.new(2000, 10, 10)]).references(:movie_times)
    puts filter
  end

end
