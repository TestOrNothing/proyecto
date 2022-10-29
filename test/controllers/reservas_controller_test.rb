# frozen_string_literal: true

require 'test_helper'

class ReservasControllerTest < ActionDispatch::IntegrationTest
  def setup
    movie = Movie.create(title: 'Matrix')
    MovieTime.create(room: 5, date_start: Date.new(2000, 11, 10),
                     date_end: Date.new(2000, 11, 12), time: 'TANDA',
                     movie_id: movie.id)
  end

  def teardown
    Reserva.destroy_all
    MovieTime.destroy_all
    Movie.destroy_all
  end
  test 'Reserva.new' do
    reserva = Reserva.new(sala: 5, fecha: Date.new(2000, 11, 10),
                          asiento: 1, horario: 'TANDA', name: 'John')
    assert_equal(true, reserva.valid?)
  end
  test 'Posting a new reserva' do
    assert_difference 'Reserva.count' do
      post new_reserva_url(5, '2000-11-12', 'TANDA'),
           params: { reservation_seats: 'C-3', name: 'Diego' }
    end
  end
  test 'Posting a new reserva with blank name' do
    post new_reserva_url(5, '2000-11-12', 'TANDA'),
      params: { reservation_seats: 'C-4', name: '' }
    assert_equal 'No se ingreso nombre para la reserva', flash[:notice]
  end
  test 'Posting a new reserva with ocupied seats' do
    post new_reserva_url(5, '2000-11-12', 'TANDA'),
      params: { reservation_seats: 'Invalid', name: 'Santiago' }
    assert_equal 'No se pudo completar la reserva ya que uno de los asientos estaba ocupado', flash[:notice]
  end
  test 'Posting a new reserva without selecting seats' do
    post new_reserva_url(5, '2000-11-12', 'TANDA'),
      params: { reservation_seats: '', name: 'Santiago' }
    assert_equal 'Selecciona uno de los asientos para crear una reserva', flash[:notice]
  end
end
