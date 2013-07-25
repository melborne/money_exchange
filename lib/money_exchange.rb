require "money_exchange/version"
require "open-uri"
require "json"

module MoneyExchange

  # Presume '#xxx_to_yyy' style methods as for money exchanges
  def method_missing(meth, *a, &b)
    md = meth.to_s.match(/^([a-z]{3})_to_([a-z]{3})$/)
    if md
      currency, target = md.captures
      Money.new(self, currency).send("to_#{target}")
    else
      super
    end
  end

  class Money
    attr_reader :amount, :currency
    def initialize(amount, currency)
      @amount = amount
      @currency = currency
    end
    
    def method_missing(meth, *a, &b)
      md = meth.to_s.match(/^to_([a-z]{3})$/)
      if md
        Exchange.calc(self, md.captures[0])
      else
        super
      end
    end
  end

  class Exchange
    class NoCurrencyDataError < StandardError; end

    class << self
      def calc(money, target)
        res = money.amount * rate(money.currency, target)
        (res * 100).round.to_f / 100
      end

      def rate(base, target)
        response = call_google_currency_api(base, target)
        rate = parse_rate(response)
      end
      
      def parse_rate(response)
        body = JSON.parse(fix_json response)

        if ['0', ''].include?(body['error']) # when no error
          body['rhs'].split(',')[0].to_f
        else
          raise NoCurrencyDataError
        end
      end

      # Because Google Currency API returns a broken json.
      def fix_json(json)
        json.gsub(/(\w+):/, '"\1":')
      end

      def call_google_currency_api(base, target)
        uri = "http://www.google.com/ig/calculator"
        query = "?hl=en&q=1#{base}=?#{target}"
        # uri = "http://rate-exchange.appspot.com/currency"
        # query = "?from=#{base}&to=#{target}&q=1"
        URI.parse(uri+query).read
      # rescue OpenURI::HTTPError => e
        # retry with vice versa
      end
    end
  end
end

class Numeric
  include MoneyExchange
end
