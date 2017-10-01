module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validation_store

    def validate(name, validation_type, *arg)
      @validation_store ||= {}
      @validation_store[name.to_sym] ||= {}
      @validation_store[name.to_sym].merge!(validation_type => arg)
    end
  end

  module InstanceMethods
    def validate!
      self.class.validation_store.each do |name, value|
        value.each do |validation_type, arg|
          send(validation_type, name, *arg)
        end
      end
    end

    def presense(name)
      var_name = get_var(name)
      raise 'Ошибка: пустое значение' if var_name.nil? || var_name.to_s.empty?
    end

    def format(name, format)
      var_name = get_var(name)
      raise "#{var_name} не соответстует формату" if var_name !~ format
    end

    def type_of(name, *type)
      var_name = get_var(name)
      raise "Ожидаемый тип #{type}" if var_name.class != type[0]
    end

    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def get_var(name)
      instance_variable_get("@#{name}".to_sym)
    end
  end
end
