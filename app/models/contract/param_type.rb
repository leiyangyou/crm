class Contract::ParamType
  attr_accessor :name


  class << self
    attr_accessor :types, :name
    def get_type_by_name name
      @types[name]
    end

    def type_names
      @types.keys
    end

    def valid_type? name
      !@types[name].nil?
    end

    def inherited base
      @types = @types || {}
      @types[base.name] = base
    end

    def name name=nil
      @name = name if name
      @name
    end
  end

  class StringType < Contract::ParamType
    name :string
    def convert string_value
      string_value
    end

    def validate value
      true
    end
  end

  class TextType < StringType
    name :text
  end

  class DateType < Contract::ParamType
    name :date
    def convert string_value
      Date.parse(string_value)
    end

    def validate value
      begin
        Date.parse(value)
        true
      rescue ArgumentError => e
        false
      end
    end
  end

  class NumberType < Contract::ParamType
    name :number
    def convert string_value
      string_value.to_i
    end

    def validate value
      /^[1-9][0-9]*$/ =~ value
    end
  end
end