require 'spec_helper'
require "stringio"

describe MoneyExchange::Command do
  before(:each) do
    FakeWeb.clean_registry
    $stdout = StringIO.new
  end

  describe '#ex command' do
    it 'returns exchanged amount' do
      mock_google_currency_api('usd', 'jpy')
      argv = ['ex', '1.00', 'usd', 'jpy']
      MoneyExchange::Command.start(argv)
      expect($stdout.string.strip).to eql '100.31'
    end
  end

  after(:each) do
    $stdout = STDOUT
  end
end
