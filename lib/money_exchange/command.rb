module MoneyExchange
  class Command < Thor
    desc "ex AMOUNT BASE *TARGETS", "Currency Exchange from base to targets"
    def ex(amount, base, *targets)
      puts amount.send("#{base}_to", *targets)
    end
  end
end

