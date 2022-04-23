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
end