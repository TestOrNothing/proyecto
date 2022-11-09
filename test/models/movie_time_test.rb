# frozen_string_literal: true

require 'test_helper'

class MovieTimeTest < ActiveSupport::TestCase
  def setup
    @movie = Movie.create(title: 'Matrix', restricted: false)
    @movietime1 = MovieTime.new(room: 5, date_start: Date.new(2001, 0o4, 10),
                                date_end: Date.new(2000, 0o7, 12),
                                time: 'Matiné',
                                movie_id: @movie.id, location: 'Santiago', lenguage: 'Español')
    @movietime2 = MovieTime.create(room: 5, date_start: Date.new(2000, 10, 10),
                                   date_end: Date.new(2001, 11, 12), time: 'TANDA',
                                   movie_id: @movie.id, location: 'Santiago', lenguage: 'Español')
    @movietime3 = MovieTime.new(room: 5, date_start: Date.new(2000, 10, 10),
                                date_end: Date.new(2001, 11, 12), time: 'TANDA',
                                movie_id: @movie.id, location: 'Santiago', lenguage: 'Español')
  end

  test 'start_date > end_date' do
    @movietime1.validate_date
    assert_equal('El día de inicio tiene que ser antes o igual al día de termino',
                 @movietime1.errors.messages[:date_start][0])
  end

  test 'query.length positive' do
    @movietime3.validate_date
    assert_equal(
      "La sala esta ocupada entre #{@movietime2.date_start} y el #{@movietime2.date_end}",
      @movietime3.errors.messages[:room][0]
    )
  end
end
