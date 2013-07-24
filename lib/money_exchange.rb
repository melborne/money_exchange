require "money_exchange/version"
require "open-uri"
require "json"

module MoneyExchange

  # Presume '#xxx_to_yyy' style methods as for money exchanges
  def method_missing(meth, *a, &b)
    case meth
    when /^([a-z]{3})_to_([a-z]{3})$/
      currency, target = $~.captures
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
      case meth
      when /^to_([a-z]{3})$/
        Exchange.calc(self, $~.captures[0])
      else
        super
      end
    end
  end

  class Exchange
    class << self
      def calc(money, target)
        res = money.amount * rate(money.currency, target)
        (res * 100).round.to_f / 100
      end

      def rate(base, target)
        response = call_google_currency_api(base, target)
        JSON.parse(fix_json response)['rhs'].split(',')[0].to_f
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
        begin
          URI.parse(uri+query).read
        rescue OpenURI::HTTPError => e
          # retry with vice versa
        end
      end
    end
  end
end

class Numeric
  include MoneyExchange
end
