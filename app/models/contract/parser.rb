require 'singleton'
class Contract::Parser
  DEFAULT_TYPE = "string"
  class << self
    #PLACE_HOLDER_PATTERN=/\${(?'name'[^:}]*)(?::(?'type'[^},]*))?(,([^:]+:[^},]+)*)}/
    PLACEHOLDER_PATTERN = /\${([^:]*):([^},]*)((?:,[^:]+:[^,}]+)*)}/
    def parse_parameters(contract, errors = nil)
      parameters = {}
      parse(contract) do |name, type, attributes|
        unless Contract::ParamType.valid_type?(type)
          errors.add(:parameters, :invalid_type, {:type => type, :name => name}) if errors
        else
          parameters[name.to_sym] = Contract::Param.new :name => name, :type => type, :attributes => attributes
        end
        nil #replace with nothing
      end
      parameters
    end

    def parse( contract)
      remain = contract
      result = ""
      while matcher = PLACEHOLDER_PATTERN.match(remain)
        remain = matcher.post_match
        result << matcher.pre_match
        name = matcher[1]
        type = matcher[2] || "string"
        attributes = parse_attributes(matcher[3])
        if replacement = yield(name, type, attributes)
          result << escape_markdown(replacement)
        else
          result << matcher[0]
        end
      end
      result << remain
    end

    private
    def escape_markdown text
      "`#{text}`"
    end
    def parse_attributes attributes
      attributes.split(",").reduce({}) do |result, section|
        if section.index(":")
          fields = section.split(":")
          result[fields[0].to_sym] = fields[1]
        end
        result
      end
    end
  end
end