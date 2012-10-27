class String
  # override the to_url of fat_free_crm with the stringex one
  alias :to_http_url :to_url
  def to_url(options = {})
    remove_formatting(options).downcase.replace_whitespace("-").collapse("-").limit(options[:limit])
  end
end