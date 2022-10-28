# frozen_string_literal: true

require 'test_helper'

class MovieTimeTest < ActiveSupport::TestCase
    def setup
        @bad_movie = Movie.create(title: 'Matrix')
      end

    test 'start_date > end_date' do 
        movietime = MovieTime.new(room: 5, date_start: Date.new(2001, 10, 10),
          date_end: Date.new(2000, 11, 12), time: 'TANDA',
          movie_id: @bad_movie.id)
          movietime.validate_date
          assert_equal('El día de inicio tiene que ser antes o igual al día de termino', movietime.errors.messages[:date_start][0])
      end
end
