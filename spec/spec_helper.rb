$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'money_exchange'

require "fakeweb"

module HelperMethods
  def fixture(name)
    File.read(File.dirname(__FILE__) + "/support/#{name}")
  end

  def mock_google_currency_api(base, target)
    uri = "http://www\.google\.com/ig/calculator"
    query = "?hl=en&q=1#{base}=?#{target}"

    begin
      response ||= fixture("rate_#{base}_to_#{target}.json")

      FakeWeb.register_uri(:get, uri+query, :body => response)
    rescue Errno::ENOENT
      response = fixture("rate_error.json")
      retry
    end
  end
end

RSpec.configuration.include(HelperMethods)

