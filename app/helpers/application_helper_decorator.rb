ApplicationHelper.class_eval do
  def show_flash(options = { :sticky => false })
    [:error, :warning, :info, :notice].each do |type|
      if flash[type]
        html = content_tag(:p, h(flash[type]), :id => "flash")
        return html << content_tag(:script, "crm.flash('#{type}', #{options[:sticky]})".html_safe, :type => "text/javascript")
      end
    end
    content_tag(:p, nil, :id => "flash", :style => "display:none;")
  end
end