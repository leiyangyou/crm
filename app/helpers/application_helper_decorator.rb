ApplicationHelper.class_eval do
  def tabs(tabs = nil)
    tabs ||= controller_path =~ /admin/ ? FatFreeCRM::Tabs.admin : FatFreeCRM::Tabs.main
    tabs = tabs.select do |tab|
      tab[:access] ? (can?(:manage, tab[:access].to_s.singularize.classify.constantize)) : true
    end
    if tabs
      @current_tab ||= tabs.first[:text] # Select first tab by default.
      tabs.each { |tab| tab[:active] = (@current_tab == tab[:text] || @current_tab == tab[:url][:controller]) }
    else
      raise FatFreeCRM::MissingSettings, "Tab settings are missing, please run <b>rake ffcrm:setup</b> command."
    end
  end

  def show_flash(options = { :sticky => false })
    [:error, :warning, :info, :notice].each do |type|
      if flash[type]
        html = content_tag(:p, h(flash[type]), :id => "flash")
        return html << content_tag(:script, "crm.flash('#{type}', #{options[:sticky]})".html_safe, :type => "text/javascript")
      end
    end
    content_tag(:p, nil, :id => "flash", :style => "display:none;")
  end

  #----------------------------------------------------------------------------
  def non_collapsible_subtitle(id, text = id.to_s.split("_").last.capitalize)
    content_tag("div",
                "<small>#{ hidden ? "&#9658;" : "&#9660;" }</small>&nbsp;#{text}".html_safe,
                :class => 'subtitle'
    )
  end

  def include_card_widget
    %Q{
    #{javascript_include_tag "widget/card_widget"}
    #{stylesheet_link_tag "widget/card_widget"}
    }.html_safe
  end


  def scoped_users_filter(asset, scope, field)
    assigned_to_filter = session[:"#{asset}_assignee_filter"] || {}
    onchange = remote_function(
      :url => {:action => :filter},
      :with => h(%Q/"#{asset}_assignee[#{field}]="+this.value/),
      :loading => "$('loading').show()",
      :complete => "$('loading').hide()"
    )
    scoped_users_select(:"#{asset}_assignee", scope, :full_description, field,
                        {:include_blank => true, :selected => assigned_to_filter[field]},
                        :style => "width:160px",
                        :onchange => onchange)
  end
  def jumpbox(current)
    tabs = [ :accounts, :leads ]
    current = tabs.first unless tabs.include?(current)
    tabs.map do |tab|
      link_to_function(t("tab_#{tab}"), "crm.jumper('#{tab}')", :class => (tab == current ? 'selected' : ''), :item => tab)
    end.join(" | ").html_safe
  end
end