class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :name, :trains
  strong_attr_accessor :name, String

  validate :name, :presense
  validate :name, :type_of, String

  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations << self
    register_instance
  end

  def take_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def send_train(train)
    @trains.delete(train)
  end

  def each_train
    @trains.each { |train| yield(train) }
  end
end
