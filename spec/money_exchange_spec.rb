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
        expect(1.00.usd_to_jpy).to eql(100.31)
      end

      it 'exchanges JPY to USD' do
        mock_google_currency_api('jpy', 'usd')
        expect(150.jpy_to_usd).to eql(1.50)
      end
      
      it 'exchanges EUR to USD' do
        mock_google_currency_api('eur', 'usd')
        expect(1.23.eur_to_usd).to eql(1.62)
      end

      it 'raise NoCurrencyDataError' do
        mock_google_currency_api('jpy', 'xxx')
        expect { 100.jpy_to_xxx }.to raise_error(nocurrency_error)
      end
    end

    it 'does not affect non-money expressions' do
      expect(1.00.to_i).to eql(1)
      expect(100.to_s).to eql('100')
      expect { 1.xxx_to_y }.to raise_error(NoMethodError)
    end
  end

  context '#xxx_to (convert to multiple currencies)' do
    it 'exchanges USD to JPY and EUR' do
      ['jpy', 'eur'].each { |target| mock_google_currency_api('usd', target) }
      expect(1.00.usd_to(:jpy, :eur)).to eql [100.31, 0.76]
    end

    it 'exchanges JPY to USD and EUR' do
      ['usd', 'eur'].each { |target| mock_google_currency_api('jpy', target) }
      expect(100.jpy_to(:usd, :eur)).to eql [1.0, 0.76]
    end

    it 'raise NoCurrencyDataError' do
      ['usd', 'xxx'].each { |target| mock_google_currency_api('jpy', target) }
      expect { 100.jpy_to(:usd, :xxx) }.to raise_error(nocurrency_error)
    end
  end
end

describe String do
  let(:nocurrency_error) { MoneyExchange::Exchange::NoCurrencyDataError }

  before(:each) do
    FakeWeb.clean_registry
  end
  
  describe '#xxx_to_yyy' do
    it 'exchanges base to target currency' do
      mock_google_currency_api('usd', 'jpy')
      expect('1.00'.usd_to_jpy).to eql(100.31)
      mock_google_currency_api('jpy', 'usd')
      expect('150'.jpy_to_usd).to eql(1.50)
      mock_google_currency_api('eur', 'usd')
      expect('1.23'.eur_to_usd).to eql(1.62)
    end

    it 'raise NoCurrencyDataError' do
      mock_google_currency_api('jpy', 'xxx')
      expect { '100'.jpy_to_xxx }.to raise_error(nocurrency_error)
    end
  end

  context '#xxx_to (convert to multiple currencies)' do
    it 'exchanges xxx to yyy and zzz' do
      ['jpy', 'eur'].each { |target| mock_google_currency_api('usd', target) }
      expect('1.00'.usd_to(:jpy, :eur)).to eql [100.31, 0.76]
      ['usd', 'eur'].each { |target| mock_google_currency_api('jpy', target) }
      expect('100'.jpy_to(:usd, :eur)).to eql [1.0, 0.76]
    end

    it 'raise NoCurrencyDataError' do
      ['usd', 'xxx'].each { |target| mock_google_currency_api('jpy', target) }
      expect { '100'.jpy_to(:usd, :xxx) }.to raise_error(nocurrency_error)
    end
  end
end
