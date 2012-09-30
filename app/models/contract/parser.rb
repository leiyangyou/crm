require 'singleton'
class Contract::Parser
  DEFAULT_TYPE = "string"
  class << self
    #PLACE_HOLDER_PATTERN=/\${(?'name'[^:}]*)(?::(?'type'[^},]*))?(,([^:]+:[^},]+)*)}/
    PLACEHOLDER_PATTERN = /\${([^:]*):([^},]*)((?:,[^:]+:[^,}]+)*)}/
    def parse_parameters(contract, errors = nil)
      parameters = {}
      parse(contract) do |name, type, params|
        unless Contract::ParamType.valid_type?(type)
          errors.add(:parameters, :invalid_type, {:type => type, :name => name}) if errors
        else
          parameters[name] = {:type => type, :params => params}
        end
        nil #replace with nothing
      end
    end

    def parse( contract)
      remain = contract
      first = true
      result = ""
      while matcher = PLACEHOLDER_PATTERN.match(remain)
        remain = matcher.post_match
        if first
          result = matcher.pre_match
        else
          first = false
        end
        name = matcher[1]
        type = matcher[2] || "string"
        params = self.parse_params(matcher[3])
        if replacement = yield(name, type, params)
          result << replacement
        else
          result << matcher[0]
        end
      end
      result << remain
    end

    private
    def parse_params params
      params.split(",").reduce({}) do |result, section|
        if section.index(":")
          fields = section.split(":")
          result[fields[0]] = fields[1]
        end
        result
      end
    end
  end
end