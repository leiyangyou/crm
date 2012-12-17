class ContractTemplateDecorator::ParamType
  attr_accessor :name

  DEFAULT_LENGTH = 20

  def extract_params params
    params.stringify_keys!.reduce({}) do |result, key, value|
      result[key] = value if params.contains?(key)
      result
    end
  end

  def default_length
    self.class.default_length || DEFAULT_LENGTH
  end

  class << self
    attr_accessor :types, :name
    def get_type_by_name name
      types[name.to_s]
    end

    def type_names
      types.keys
    end

    def valid_type? name
      !types[name.to_s].nil?
    end
    @@types = {}
    def types
      @@types
    end

    def params
      @params ||= []
    end

    def param name
      params << name.to_s
    end

    def name name=nil
      if name
        @name = name.to_s
        types[@name] = self.new
      end
      @name
    end

    def default_length length=nil
      @length = length if length
      @length
    end
  end

  class StringType < ContractTemplateDecorator::ParamType
    name :string
    def convert string_value, default_value=""
      string_value
    end

    def validate value
      true
    end
  end

  class TextType < StringType
    name :text
  end

  class DateType < ContractTemplateDecorator::ParamType
    name :date
    def convert string_value, default_value=Date.today
      begin
        Date.parse(string_value)
      rescue Exception
        default_value
      end
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

  class NumberType < ContractTemplateDecorator::ParamType
    name :number
    def convert string_value, default_value=0
      begin
        string_value.to_i
      rescue Exception
        default_value
      end
    end

    def validate value
      /^[1-9][0-9]*$/ =~ value
    end
  end
end