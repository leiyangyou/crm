source 'http://rubygems.org'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'rails', '3.2.8'
gem "stringex", "~> 1.4.0"
gem 'fat_free_crm'

gem 'ransack',      :git => "git://github.com/fatfreecrm/ransack.git"
gem 'chosen-rails', :git => "git://github.com/fatfreecrm/chosen-rails.git"
gem 'responds_to_parent', :git => "https://github.com/LessonPlanet/responds_to_parent.git"

gem 'mysql2'
gem 'canard'
gem 'authlogic', '=3.1.0'
gem "surveyor"
gem 'pdfkit'
gem "markdown", "~> 1.0.0"
gem "state_machine", "~> 1.1.2"
gem 'carrierwave', "~> 0.6.2"

if RUBY_PLATFORM =~ /darwin/
  gem 'wkhtmltopdf-binary'
else
  gem 'wkhtmltopdf'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "compass-rails", "~> 1.0.3"

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem "jquery-ui-rails"
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development do
  gem 'pry-rails'
  gem 'rb-readline', '~> 0.4.2'
end

gem 'thin'

gem 'serializable_attributes', :path => "vendor/gems/serializable_attributes-1.1.1"
