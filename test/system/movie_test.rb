# frozen_string_literal: true

require 'application_system_test_case'

class MoviesTest < ApplicationSystemTestCase
  setup do
    @restricted_movie_regional = Movie.create(title: 'SAW', image: nil, restricted: true)
    @restricted_time_Ingles_regional = MovieTime.create(room: 1, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @restricted_movie_regional.id, location: 'Regional', lenguage: 'Ingles')
    @restricted_time_espanol_regional = MovieTime.create(room: 2, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @restricted_movie_regional.id, location: 'Regional', lenguage: 'Español')

    @non_restricted_movie_regional = Movie.create(title: 'Matrix', image: nil, restricted: false)
    @non_restricted_time_Ingles_regional = MovieTime.create(room: 3, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @non_restricted_movie_regional.id, location: 'Regional', lenguage: 'Ingles')
    @non_restricted_time_espanol_regional = MovieTime.create(room: 4, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @non_restricted_movie_regional.id, location: 'Regional', lenguage: 'Español')

    @restricted_movie_santiago = Movie.create(title: 'SAW II', image: nil, restricted: true)
    @restricted_time_Ingles_santiago = MovieTime.create(room: 5, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @restricted_movie_santiago.id, location: 'Santiago', lenguage: 'Ingles')
    @restricted_time_espanol_santiago = MovieTime.create(room: 6, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @restricted_movie_santiago.id, location: 'Santiago', lenguage: 'Español')

    @non_restricted_movie_santiago = Movie.create(title: 'Matrix II', image: nil, restricted: false)
    @non_restricted_time_Ingles_santiago = MovieTime.create(room: 7, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @non_restricted_movie_santiago.id, location: 'Santiago', lenguage: 'Ingles')
    @non_restricted_time_espanol_santiago = MovieTime.create(room: 8, date_start: Date.new(2020, 10, 10),
                              date_end: Date.new(2020, 10, 10), time: 'TANDA',
                              movie_id: @non_restricted_movie_santiago.id, location: 'Santiago', lenguage: 'Español')
                    
  end
  
  def teardown
    MovieTime.destroy_all
    Movie.destroy_all
  end

  test 'Mayor de Edad, Regional, Ingles' do
    visit '/movies/list?date=2020-10-10&age=Mayor+de+edad&idioma=Ingles&place=Regional&commit=Buscar'

    assert_text @restricted_movie_regional.title
    assert_no_text @restricted_movie_santiago.title
    assert_no_text @non_restricted_movie_santiago.title
    assert_text "Solo apta para mayores de edad"
  end

  test 'Menor de Edad, Regional, Ingles' do
    visit '/movies/list?date=2020-10-10&age=Menor+de+edad&idioma=Ingles&place=Regional&commit=Buscar'

    assert_text @non_restricted_movie_regional.title
    assert_no_text @restricted_movie_santiago.title
    assert_no_text @non_restricted_movie_santiago.title
    assert_text "Apta para todo publico"
    assert_no_text "Solo apta para mayores de edad"
  end

  test 'Mayor de Edad, Santiago, Ingles' do
    visit '/movies/list?date=2020-10-10&age=Mayor+de+edad&idioma=Ingles&place=Santiago&commit=Buscar'

    assert_text @restricted_movie_santiago.title
    assert_no_text @restricted_movie_regional.title
    assert_no_text @non_restricted_movie_regional.title
    assert_text "Solo apta para mayores de edad"
  end

end
