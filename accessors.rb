module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}"
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        @history ||= {}
        @history[var_name] ||= []
        @history[var_name] << value
      end
      define_method("#{name}_history".to_sym) { @history[var_name] unless @history.nil? }
    end
  end

  def strong_attr_accessor(name, expected_class)
    var_name = "@#{name}"
    define_method(name) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise "Ожидаемый класс #{expected_class}" unless value.is_a?(expected_class)
      instance_variable_set(var_name, value)
    end
  end
end
