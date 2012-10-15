module ActionView
  module Helpers
    module ContractHelper
      def template_attributes(object_name, method, options={}, html_options={})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_template_attributes_tag(options, html_options)
      end
    end
    ActionView::Base.class_eval do
      include ContractHelper
    end if defined? ActionView::Base

    module ContractHelperInstanceTag
      def to_template_attributes_tag(options={}, html_options={})
        template_method = options.delete(:template_method) || "contract_template"
        template = @object.send(template_method)
        parameters = @object.send(@method_name) || {}
        result = ""
        result << tag("table", {:id => "#{tag_id}_table"}, true)
          template.parameters.each do |name, parameter|
            @sanitized_method_name = "parameter_attributes"
            instance_tag = InstanceTag.new(tag_name, name, @template_object, parameters)
            result << tag("tr", {}, true)
              result << tag("td", {}, true)
                result << instance_tag.to_label_tag
              result << tag("/td", {}, true)
              result << tag("td", {}, true)
                case parameter.type
                  when "string"
                    result << instance_tag.to_input_field_tag("text", options)
                  when "date"
                    result << instance_tag.to_date_select_tag(options, html_options)
                  when "number"
                    result << instance_tag.to_input_field_tag("text", options)
                  when "text"
                    result << instance_tag.to_text_area_tag(options)
                end
              result << tag("/td", {}, true)
            result << tag("/tr", {}, true);
          end
        result << tag("/table", {}, true)
        result.html_safe
      end
    end
    class InstanceTag
      include ContractHelperInstanceTag
    end

    class FormBuilder
      def template_attributes(method, options={}, html_options={})
        @template.template_attributes(@object_name, method, objectify_options(options), html_options)
      end
    end
  end
end