# Install gems on gemfile change
guard 'bundler' do
  watch('Gemfile')
end

# Reload server on important file changes
guard 'rack' do
  watch('Gemfile.lock')
  watch(%r{^(app)/.*})
end

# Auto run minitest specs
guard :minitest, all_on_start: false do
  watch(%r{^spec/(.*)_spec\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})         { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper\.rb$}) { 'spec' }
end
