source 'https://rubygems.org/'

ruby '~> 2.5.3'

# Rack server
gem 'puma'

# Main framework
gem 'sinatra'

# Rake commands
gem 'rake'

# Automatic server reloader on files change
gem 'sinatra-reloader'

# For JSON to XML methods
gem 'builder'
gem 'activesupport'

# For creating HTTP requests
gem 'excon', '~> 0.64.0'

# New relic
gem 'newrelic_rpm'

gem 'ruby-limiter'

group :development do
  # Interactive REPL
  gem 'pry'

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

  # For mocking out and replaying interactions with external services
  gem 'vcr'
  gem 'webmock'

  # Additional methods for minitest
  gem 'maxitest'
end
