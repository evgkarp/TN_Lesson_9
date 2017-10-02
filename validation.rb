module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validation_store

    def validate(name, validation_type, arg = 0)
      @validation_store ||= {}
      @validation_store[name.to_sym] ||= {}
      @validation_store[name.to_sym].merge!(validation_type => arg)
    end
  end

  module InstanceMethods
    def validate!
      self.class.validation_store.each do |name, value|
        var_name = get_var(name)
        value.each do |validation_type, arg|
          send(validation_type, var_name, arg)
        end
      end
    end

    def valid?
      validate!
      true
    rescue
      false
    end

   private

    def presense(var_name, arg)
      raise 'Ошибка: пустое значение' if var_name.to_s.empty?
    end

    def validate_format(var_name, format)
      raise "#{var_name} не соответстует формату" if var_name !~ format
    end

    def type_of(var_name, type)
      raise "Ожидаемый тип #{type}" if var_name.class != type
    end

    def get_var(name)
      instance_variable_get("@#{name}".to_sym)
    end
  end
end
