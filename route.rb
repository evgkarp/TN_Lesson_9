class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :start, :finish

  validate :start, :presense
  validate :start, :type_of, Station
  validate :finish, :presense
  validate :finish, :type_of, Station

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations = [start, finish]
    validate!
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    raise 'Нельзя удалить первую станцию маршрута' if station == @stations[0]
    raise 'Нельзя удалить конечную станцию маршрута' if station == @stations[-1]
    @stations.delete(station)
  end
end
