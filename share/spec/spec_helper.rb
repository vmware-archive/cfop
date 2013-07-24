require "#{ENV["_CFOP_ROOT"]}/share/put_cfop_on_load_path"
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

require "rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixtures_path
  File.join(ENV["_CFOP_ROOT"], "share", "spec", "fixtures")
end
