module ActionView
  module Helpers
    module AppointmentHelper
      def time_range_select(object_name, method, options={}, html_options={})
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_time_range_select_tag(options, html_options)
      end
    end
    ActionView::Base.class_eval do
      include AppointmentHelper
    end if defined? ActionView::Base

    module AppointmentHelperInstanceTag
      VALID_TIMES = (0..23).reduce([]){|result, hour| result.concat(["#{hour}:00", "#{hour}:30"])}
      def to_time_range_select_tag(options={}, html_options={})
        options
        select_options = {
          :id => input_id,
          :name => input_name
        }.merge(html_options)

        select_html = "\n"
        VALID_TIMES.each do |valid_time|
          value = value_before_type_cast(object)
          option_options = {}
          puts "#{@method_name}:#{value.hour}:#{value.min} == #{valid_time}" if value
          option_options[:selected] = "selected" if value && "#{value.hour}:#{value.min}" == valid_time
          select_html << content_tag(:option, valid_time, option_options)
        end
        (content_tag(:select, select_html.html_safe, select_options) + "\n").html_safe
      end

      def input_id
        id = self.input_name.gsub(/([\[\(])|(\]\[)/, '_').gsub(/[\]\)]/, '')
        id
      end

      def input_name
        tag_name
      end
    end
    class InstanceTag
      include AppointmentHelperInstanceTag
    end

    class FormBuilder
      def time_range_select(method, options={}, html_options={})
        @template.time_range_select(@object_name, method, objectify_options(options), html_options)
      end
    end
  end
end