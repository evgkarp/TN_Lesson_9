class PassengerWagon < Wagon
  include Validation

  attr_reader :busy_seats, :number_of_seats

  validate :number_of_seats, :presense
  validate :number_of_seats, :type_of, Integer

  def initialize(number_of_seats)
    super
    @type = :passenger
    @number_of_seats = number_of_seats
    validate!
    @busy_seats = 0
  end

  def take_seat
    raise 'Нет свободных мест' if free_seats.zero?
    @busy_seats += 1
  end

  def free_seats
    @number_of_seats - @busy_seats
  end
end
