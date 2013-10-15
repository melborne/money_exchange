# MoneyExchange

Just another currency converter based on [Google's Currency Converter and JSON API](http://motyar.blogspot.jp/2011/12/googles-currency-converter-and-json-api.html "Google's Currency Converter and JSON API"). 

## Installation

Add this line to your application's Gemfile:

    gem 'money_exchange'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install money_exchange

## Usage

Require it and available `#xxx_to_yyy` and `#xxx_to` for Fixnum and String.

```ruby
1.usd_to_jpy
# => 98.46

1.usd_to(:jpy, :eur, :mxn)
# => [98.46, 0.74, 12.97]
```

## Command

It comes with `money_exchange` command. Just type it on your terminal and read the help.

## Thank you

I got some hits from [codegram/simple_currency](https://github.com/codegram/simple_currency). Thank you.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
