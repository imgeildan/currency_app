require 'test_helper'

class CurrenciesIntegrationTest < ActionDispatch::IntegrationTest
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

	context 'index' do
		context 'instance variables' do
			should 'be present' do
				get currencies_path
				assert_response :success
				assert assigns(:currencies)
				assert_equal %W[USD EUR CHF], assigns(:currency_names)
				assert_nil assigns(:converted_number)
			end

			should 'be empty' do
				Currency.delete_all

				get currencies_path
				assert_response :success

				assert_empty assigns(:currencies)
				assert_empty assigns(:currency_names)
				assert_nil assigns(:converted_number)
			end

			should 'converted_number' do
				get currencies_path, params: { value: 100, currency_from: 'USD', currency_to: 'EUR' }
				assert_response :success
				assert_equal 92.6031, assigns(:converted_number)
			end
		end
	end

	test 'create currencies' do
		Currency.delete_all

		assert_difference('Currency.count', 3) do
			post currencies_path
			assert_response :found
			assert_equal 'Successfully created', flash[:notice]
		end
	end

	test 'update currencies' do
    	assert_no_difference 'Currency.count' do
    		put fetch_data_currencies_path
	 		assert_response :found
	 		assert_equal 'Successfully updated', flash[:notice]
    	end
    end    
end