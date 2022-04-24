require 'test_helper'
require 'json'

module CurrencyManager
	class CurrencyCreatorTest < ActiveSupport::TestCase
		setup do
			@successful_response = {
				success:	true, 
				terms:  	'https://currencylayer.com/terms', 
				privacy:	'https://currencylayer.com/privacy', 
				timestamp:  1650787934, 
				source:		'USD', 
				quotes:	    { 'USDUSD' => 1, 'USDEUR' => 0.92598, 'USDCHF' => 0.957491 } }

			header = {
				'Accept'	  	 =>'*/*',
				'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
				'Host'			 =>'api.currencylayer.com',
				'User-Agent' 	 =>'Ruby'
			}

			url = 'http://api.currencylayer.com/live?access_key=619f9c88ece35e260da483fce9ffae1f&currencies=USD,EUR,CHF'
			stub_request(:get, url).with(headers: header).to_return(status: 200, body: @successful_response.to_json)
		end

		test 'perform' do
			currency_creator = CurrencyManager::CurrencyCreator.new
			assert @successful_response, currency_creator.call
		end
	end
end