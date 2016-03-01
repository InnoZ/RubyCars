require 'pathname'

ROOT = Pathname(__FILE__).parent.parent
$LOAD_PATH << ROOT
$LOAD_PATH << ROOT.join('app')

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
