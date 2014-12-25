source 'https://rubygems.org/'

ruby '2.1.5'

# Rack server
gem 'thin'

# Main framework
gem 'sinatra'

# Rake commands
gem 'rake'

# Automatic server reloader on files change
gem 'sinatra-reloader'

# For JSON to XML methods
gem 'builder'
gem 'activesupport'

group :development do
  # Advanced interactive error handling
  gem 'better_errors'
  gem 'binding_of_caller'

  # Automatic server reload on file changes
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rack'
  gem 'guard-minitest'
end

group :test do
  # Colourful minitest results
  gem 'minitest-reporters'

  # Needed for testing requests
  gem 'rack-test'
end

# For creating HTTP requests
gem 'patron'