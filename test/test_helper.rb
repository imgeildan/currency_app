ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  Shoulda::Matchers.configure do |config|
  	config.integrate do |with|
  		with.test_framework :minitest
  		with.library :rails
  	end
  end

  WebMock.disable_net_connect!(allow_localhost: true)
end


class ActiveJob::TestCase
	setup do
		@successful_response = {
			'success'   => true, 
			'terms'     => 'https://currencylayer.com/terms', 
			'privacy'   => 'https://currencylayer.com/privacy', 
			'timestamp' => 1650787934, 
			'source'	=> 'USD', 
			'quotes'	=> { 'USDUSD'=>1, 'USDEUR'=>0.92598, 'USDCHF'=>0.957491 } 
		}

		@header = {
			'Accept'	  	  =>'*/*',
			'Accept-Encoding' =>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
			'Host'			  =>'api.currencylayer.com',
			'User-Agent' 	  =>'Ruby'
		}

		@access_key = Rails.application.credentials.money[:access_key]
		url 	   = "http://api.currencylayer.com/live?access_key=#{@access_key}&currencies=USD,EUR,CHF"

		stub_request(:get, url).with(headers: @header).to_return(status: 200, body: @successful_response.to_json)

		@failed_response = {
			'success' => false, 
			'error'   => { 'code' => 103, 'info' => 'This API Function does not exist.' }
		}

		@wrong_url = "http://api.currencylayer.com/li?access_key=123&currencies=USD,EUR,CHF"
	end
end
