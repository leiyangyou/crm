require 'singleton'
class Contract::Parser
  include Singleton

  PLACE_HOLDER_PATTERN=/\${(?'name'[^\|}]*)(?:\|(?'type'[^}]*))?}/
  def parse(contract, errors)
    pos = 0
    parameters = {}
    while matcher = PLACE_HOLDER_PATTERN.match(contract, pos)
      pos = matcher.end(0)
      name = matcher['name']
      type = matcher['type'] || "string"
      unless Contract::ParamType.valid_type?(type)
        errors.add_error("parameters.#{type}", :invalid_type, {:type => type})
        next
      end
      parameters[name] = type
    end
    parameters
  end
end