require 'markdown'
module ContractTemplateDecorator
end
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

  attr_accessible :template, :format, :contract_type
  serialize :parameters, Hash

  validates_inclusion_of :format, :in => Format::AVAILABLE
  validates_uniqueness_of :contract_type

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
    template = ContractTemplateDecorator::Parser.parse(self.template) do |name, type, params|
      type = ContractTemplateDecorator::ParamType.get_type_by_name type
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

  def to_preview
    template = ContractTemplateDecorator::Parser.parse(self.template) do |name, type, params|
      type = ContractTemplateDecorator::ParamType.get_type_by_name type
      length = (params[:length] || type.default_length).to_i
      ("%-#{length * 2}s" % "(#{name})")
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
      type = ContractTemplateDecorator::ParamType.get_type_by_name parameter.type
      raise TypeValidationError.new( parameter.type) unless type && type.validate(param)
    end
  end

  def generate_contract contract
    template = ContractTemplateDecorator::Parser.parse(self.template) do |name, type, attributes|
      value = contract.respond_to?(name.to_sym) ? contract.send(name.to_sym) : nil
      unless value
        type = ContractTemplateDecorator::ParamType.get_type_by_name type
        length = (params[:length] || type.default_length).to_i
        value = "_" * length
      end
      value.to_s
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

  protected

  def parse_and_refresh_parameters
    parameters = ContractTemplateDecorator::Parser.parse_parameters( self.template, self.errors)
    self.parameters = parameters
  end
end
require File.join(File.dirname(__FILE__), "/contract_template_decorator/param") #to fix the yaml-dump


