$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'money_exchange'

require "fakeweb"

module HelperMethods
  def fixture(name)
    File.read(File.dirname(__FILE__) + "/support/#{name}")
  end

  def mock_google_currency_api(base, target)
    uri = "http://rate-exchange.appspot.com/currency"
    query = "?from=#{base}&to=#{target}&q=1"
    response = {body: fixture("currency_rate.json")}
    
    FakeWeb.register_uri(:get, uri+query, :body => response)
  end
end

RSpec.configuration.include(HelperMethods)

