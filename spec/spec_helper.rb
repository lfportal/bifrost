require 'azure'
require 'byebug'
require 'dotenv'
require 'simplecov'

# Load environment variables for Azure
Dotenv.load('.env.test')

# We need to load the environment before the bifrost
require 'bifrost'

SimpleCov.start do
  add_filter '/spec/'
end

RSpec.configure do |config|
  # All specs use this pre-defined namespace in Azure
  Azure.sb_namespace = ENV['AZURE_BUS_NAMESPACE']

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # Clear the bifrost before running each spec
  config.before(:example) do
    bus = Bifrost::Bus.new
    bus.topics.each(&:delete)
  end

  # Clear the bifrost after running specs
  config.after(:suite) do
    bus = Bifrost::Bus.new
    bus.topics.each(&:delete)
  end
end
