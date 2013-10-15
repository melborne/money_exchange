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
      res = "\e[32mUSD\e[0m 1.00  => \e[32mJPY\e[0m 100.31\n             \e[32m\e[0m"
      expect($stdout.string.strip).to eql res
    end
  end

  after(:each) do
    $stdout = STDOUT
  end
end
