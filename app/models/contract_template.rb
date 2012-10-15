require 'markdown'
# template for contract,
# can take placeholders in the form of ${name:type[,param1:value]*} for farther customizing.
#
# The template itself should be written in Markdown( I dont want to build a Rich Content Editor),
# but it's not easy to express all the content with markdown, so i'm considering to enable
# using attachments as the content of the contract, and only require the user to fill all the blacks
# back.
class ContractTemplate < ActiveRecord::Base
  module Format
    MARKDOWN = "markdown"
    HTML = "html"
    AVAILABLE = [MARKDOWN, HTML]
  end
  class ValidationError < Error
  end
  class TypeValidationError < ValidationError
    attr_accessor :type
    def initialize(type)
      @type = type
    end
  end
  class ParamRequiredError < ValidationError
  end

  belongs_to :contract_type

  attr_accessible :template, :format
  serialize :parameters, Hash

  validates_inclusion_of :format, :in => Format::AVAILABLE

  before_validation(:on => :create) do
    self.parse_and_refresh_parameters
  end

  before_validation(:on => :update) do
    if self.template_changed?
      self.parse_and_refresh_parameters
    end
  end

  # convert the contract to its printable form( a html) with all the placeholders are replaces by underlines
  def to_printable
    template = ContractTemplate::Parser.parse(self.template) do |name, type, params|
      type = ContractTemplate::ParamType.get_type_by_name type
      length = (params[:length] || type.default_length).to_i
      "_" * length
    end
    case self.format
      when Format::MARKDOWN
        Markdown.new(template).to_html
      when Format::HTML
        template
      else
        "Unrecognizable format: '#{self.format}'"
    end
  end

  def validate_params params
    params.symbolize_keys!
    self.parameters.each do |key, parameter|
      param = params[key]
      raise ParamRequiredError unless param || !parameter.required?
      type = ContractTemplate::ParamType.get_type_by_name parameter.type
      raise TypeValidationError.new( parameter.type) unless type && type.validate(param)
    end
  end

  def generate_contract params
    contract = Contract.new params
    contract.template = self
    #TODO figure out how to fill in the rest params like start time / end time
    contract
  end

  protected

  def parse_and_refresh_parameters
    parameters = ContractTemplate::Parser.parse_parameters( self.template, self.errors)
    self.parameters = parameters
  end
end
require File.join(File.dirname(__FILE__), "/contract_template/param") #to fix the yaml-dump

