require "money_exchange/version"
require "money_exchange/command"
require "open-uri"
require "json"

module MoneyExchange

  # Presume '#xxx_to' style methods as for money exchanges
  def method_missing(meth, *a, &b)
    case meth
    when /^([a-z]{3})_to_([a-z]{3})$/
      currency, target = $~.captures
      Money.new(self, currency).send("to_#{target}")
    when /^([a-z]{3})_to$/
      currency, targets = $~[1], a
      targets.map { |t| Money.new(self, currency).send("to_#{t}") }
    else
      super
    end
  end

  class Money
    attr_reader :amount, :currency
    def initialize(amount, currency)
      @amount = Float(amount)
      @currency = currency
    end
    
    def method_missing(meth, *a, &b)
      case meth
      when /^to_([a-z]{3})$/
        Exchange.calc(self, $~[1])
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

class String
  include MoneyExchange
end
