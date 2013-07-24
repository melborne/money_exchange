require 'spec_helper'

describe MoneyExchange do
  it 'should have a version number' do
    MoneyExchange::VERSION.should_not be_nil
  end
end

describe Numeric do
  before(:each) do
  end
  
  describe '#xxx_to_yyy' do
    it 'convert self in XXX currency to YYY currency' do
      mock_google_currency_api('usd', 'jpy')
      1.00.usd_to_jpy.should eql 100.31
      mock_google_currency_api('jpy', 'usd')
      150.jpy_to_usd.should eql 1.50
      mock_google_currency_api('eur', 'usd')
      1.23.eur_to_usd.should eql 1.62
    end

    it 'does not affect non-money expressions' do
      1.00.to_i.should eql 1
      100.to_s.should eql '100'
      expect { 1.xxx_to_y }.to raise_error(NoMethodError)
    end
  end
end
