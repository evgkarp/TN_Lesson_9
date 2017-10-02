class CargoTrain < Train
  validate :number, :presense
  validate :number, :validate_format, /^[а-я\d]{3}-?[а-я\d]{2}$/i
  validate :number, :type_of, String

  def initialize(number)
    super
    @type = :cargo
  end
end
