$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'money_exchange'

require "fakeweb"

module HelperMethods
  def fixture(name)
    File.read(File.dirname(__FILE__) + "/support/#{name}")
  end

  def mock_google_currency_api(base, target)
    uri_re = %r|http://www\.google\.com/ig/calculator|
    begin
      response ||= fixture("rate_#{base}_to_#{target}.json")

      FakeWeb.register_uri(:get, uri_re, :body => response)
    rescue Errno::ENOENT
      response = fixture("rate_error.json")
      retry
    end
  end
end

RSpec.configuration.include(HelperMethods)

