require 'test_helper'

class CurrenciesIntegrationTest < ActionDispatch::IntegrationTest
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

	context 'create update' do
		setup do
			@successful_response = {
				success:	true, 
				terms:  	'https://currencylayer.com/terms', 
				privacy:	'https://currencylayer.com/privacy', 
				timestamp:  1650787934, 
				source:		'USD', 
				quotes:	    { 'USDUSD' => 1, 'USDEUR' => 0.92598, 'USDCHF' => 0.957491 } }

			@header = {
				'Accept'	  	 =>'*/*',
				'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
				'Host'			 =>'api.currencylayer.com',
				'User-Agent' 	 =>'Ruby'
			}

			access_key = Rails.application.credentials.money[:access_key]
			@url 	   = "http://api.currencylayer.com/live?access_key=#{access_key}&currencies=USD,EUR,CHF"
			
			stub_request(:get, @url).with(headers: @header).to_return(status: 200, body: @successful_response.to_json)
		end

		should 'create currencies' do
			Currency.delete_all

			assert_difference('Currency.count', 3) do
				post currencies_path
				assert_response :found
				assert_equal 'Successfully created', flash[:notice]
				assert_equal %w[USD EUR CHF], Currency.pluck(:name)
				assert_equal [1, 0.92598,  0.957491], Currency.pluck(:rate)
			end
		end

		should 'update currencies' do
			@updated_response = {
				success:	true, 
				terms:  	'https://currencylayer.com/terms', 
				privacy:	'https://currencylayer.com/privacy', 
				timestamp:  1650787934, 
				source:		'USD', 
				quotes:	    { 'USDUSD' => 2, 'USDEUR' => 1, 'USDCHF' => 3 } }

			stub_request(:get, @url).with(headers: @header).to_return(status: 200, body: @updated_response.to_json)

	    	assert_no_difference 'Currency.count' do
	    		put fetch_data_currencies_path
		 		assert_response :found
		 		assert_equal [2, 1, 3], Currency.pluck(:rate)
		 		assert_equal 'Successfully updated', flash[:notice]
	    	end
	    end  
	end  
end