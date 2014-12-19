# Install gems on gemfile change
guard 'bundler' do
  watch('Gemfile')
end

# Reload server on important file changes
guard 'rack' do
  watch('Gemfile.lock')
  watch(%r{^(app)/.*})
end