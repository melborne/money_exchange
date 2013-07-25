require 'spec_helper'

describe MoneyExchange do
  it 'should have a version number' do
    MoneyExchange::VERSION.should_not be_nil
  end
end

describe Numeric do
  before(:each) do
    FakeWeb.clean_registry
  end
  
  describe '#xxx_to_yyy' do
    let(:nocurrency_error) { MoneyExchange::Exchange::NoCurrencyDataError }

    context 'convert self in XXX currency to YYY currency' do
      it 'exchanges USD to JPY' do
        mock_google_currency_api('usd', 'jpy')
        1.00.usd_to_jpy.should eql 100.31
      end

      it 'exchanges JPY to USD' do
        mock_google_currency_api('jpy', 'usd')
        150.jpy_to_usd.should eql 1.50
      end
      
      it 'exchanges EUR to USD' do
        mock_google_currency_api('eur', 'usd')
        1.23.eur_to_usd.should eql 1.62
      end

      it 'raise NoCurrencyDataError' do
        mock_google_currency_api('jpy', 'xxx')
        expect { 100.jpy_to_xxx }.to raise_error(nocurrency_error)
      end
    end

    it 'does not affect non-money expressions' do
      1.00.to_i.should eql 1
      100.to_s.should eql '100'
      expect { 1.xxx_to_y }.to raise_error(NoMethodError)
    end
  end
end
