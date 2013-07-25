require 'spec_helper'

describe MoneyExchange do
  it 'should have a version number' do
    MoneyExchange::VERSION.should_not be_nil
  end
end

describe Numeric do
  let(:nocurrency_error) { MoneyExchange::Exchange::NoCurrencyDataError }

  before(:each) do
    FakeWeb.clean_registry
  end
  
  describe '#xxx_to_yyy' do
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

  context 'convert self to multiple currencies' do
    it 'exchanges USD to JPY and EUR' do
      ['jpy', 'eur'].each { |target| mock_google_currency_api('usd', target) }
      1.00.usd_to(:jpy, :eur).should eql [100.31, 0.76]
    end

    it 'exchanges JPY to USD and EUR' do
      ['usd', 'eur'].each { |target| mock_google_currency_api('jpy', target) }
      100.jpy_to(:usd, :eur).should eql [1.0, 0.76]
    end

    it 'raise NoCurrencyDataError' do
      ['usd', 'xxx'].each { |target| mock_google_currency_api('jpy', target) }
      expect { 100.jpy_to(:usd, :xxx) }.to raise_error(nocurrency_error)
    end
  end


end
