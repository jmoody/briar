module Briar
  class Environment

    def self.variable(variable_name)
      ENV[variable_name]
    end

    def self.set_variable(variable_name, value)
      ENV[variable_name] = value
    end
  end
end
