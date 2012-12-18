module SerializableAttributes::Format::YAML
  extend self

  def encode(body)
    return nil if body.blank?
    ActiveRecord::Coders::YAMLColumn.new.dump(body)
  end

  def decode(body)
    return {} if body.blank?
    ActiveRecord::Coders::YAMLColumn.new.load(body)
  end
end

SerializableAttributes::Schema.default_formatter= SerializableAttributes::Format::YAML

SerializableAttributes::ModelMethods.class_eval do
  def serialize_attributes(field = :data, options = {:blob => :parameters}, &block)
    schema = SerializableAttributes::Schema.new(self, field, options)
    schema.instance_eval(&block)
    schema.fields.freeze
    schema
  end
end

module SerializableAttributes::InstanceMethods
  def column_for_attribute(attribute)
    super(attribute) || self.class.data_schema.fields[attribute.to_s]
  end
end

module SerializableAttributes
  class String
    def klass
     ::String
    end
  end
  class Integer
    def klass
      ::Integer
    end
  end
  class Float
    def klass
      ::Float
    end
  end
  class Boolean
    def klass
      ::Boolean
    end
  end
  class Time
    def klass
      ::Time
    end
    def type
      :datetime
    end
  end

  class Date < AttributeType
    def parse(input)
      return nil if input.blank?
      case input
        when ::Date   then input
        when ::String then ::Date.parse(input)
        else input.to_date
      end
    end
    def encode(input) input ? input.to_s("%Y-%m-%d"): nil end
    def klass
      ::Date
    end
  end

  add_type :date, Date
end


SerializableAttributes.setup
ActiveRecord::Base.send :include, SerializableAttributes::InstanceMethods
