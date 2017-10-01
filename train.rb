class Train
  include Maker
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :type, :wagons, :route
  attr_accessor_with_history :speed
  strong_attr_accessor :number, String

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    validate!
    @speed = 0
    @station_index = 0
    @wagons = []
    @@trains[number] = self
    register_instance
  end

  def speed_up
    @speed += 10
  end

  def stop
    @speed = 0
  end

  def route=(route)
    @route = route
    @station_index = 0
    current_station.take_train(self)
  end

  def go_forward
    last_station
    current_station.send_train(self)
    @station_index += 1
    current_station.take_train(self)
  end

  def go_backward
    first_station
    current_station.send_train(self)
    @station_index -= 1
    current_station.take_train(self)
  end

  def current_station
    @route.stations[@station_index]
  end

  def next_station
    last_station
    @route.stations[@station_index + 1]
  end

  def previous_station
    first_station
    @route.stations[@station_index - 1]
  end

  def add_wagon(wagon)
    @wagons << wagon if @speed.zero? && type == wagon.type
  end

  def delete_wagon
    wagons_empty
    raise 'Нельзя отцепить вагон пока поезд движется' if @speed > 0
    @wagons.pop
  end

  def wagons_empty
    raise 'Нет ни одного вагона у этого поезда' if @wagons.empty?
  end

  def each_wagon
    @wagons.each { |wagon| yield(wagon) }
  end

  protected

  def first_station
    output = 'Поезд находится на первой станции'
    raise output if @route.stations[@station_index] == @route.stations[0]
  end

  def last_station
    output = 'Поезд находится на конечной станции'
    raise output if @route.stations[@station_index] == @route.stations[-1]
  end
end
