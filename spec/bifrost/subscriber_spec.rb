require 'spec_helper'
require 'bifrost'

describe Bifrost::Subscriber do
  subject(:subscriber) { Bifrost::Subscriber.new('subscriber_name') }

  it { is_expected.to respond_to(:name) }
end
