require "thor"

module MoneyExchange
  class Command < Thor
    desc "ex AMOUNT BASE *TARGETS", "Currency Exchange from base to targets"
    def ex(amount, base, *targets)
      results = amount.send("#{base.downcase}_to", *targets.map(&:downcase))
      print_in_format(amount, base, targets, results)
    rescue Exchange::NoCurrencyDataError
      abort "no exchange data for any of them. see help."
    rescue
      abort "you might pass wrong codes. see help."
    end

    no_commands do
      def print_in_format(amount, base, targets, results)
        from = "#{base.upcase} #{amount}  => "
        padding = ' ' * from.size
        head = [from] + [padding] * targets.size
        head.zip(targets.map(&:upcase), results).map do |h, t, r|
          h = h.sub(/^\w{3}/) { "#{c $&, 32}" }
          puts "%s%s %s" % [h, c(t), r]
        end
      end

      def c(str, d='32')
        "\e[#{d}m#{str}\e[0m"
      end
    end

    desc "version", "Show MoneyExchange version"
    def version
      puts "MoneyExchange #{MoneyExchange::VERSION} (c) 2013 kyoendo"
    end
    map "-v" => :version
  
    desc "banner", "Describe MoneyExchange usage", hide:true
    def banner
      banner = ~<<-EOS
      Available currency codes:
        AUD: Australian dollar
        CAD: Canadian dollar
        CHF: Swiss franc
        CNY: Chinese yuan
        DKK: Danish krone
        EUR: Euro
        GBP: British pound
        HKD: Hong Kong dollar
        HUF: Hungarian forint
        INR: Indian rupee
        JPY: Japanese yen
        MXN: Mexican peso
        NOK: Norwegian krone
        NZD: New Zealand dollar
        PLN: Polish złoty
        SEK: Swedish krona
        SGD: Singapore dollar
        TRY: Turkish lira
        USD: United States Dollar
        ZAR: South African rand
      EOS
      help
      puts banner
    end
    default_task :banner
    map "-h" => :banner
  end
end

