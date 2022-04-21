require 'test_helper'

class CurrenciesIntegrationTest < ActionDispatch::IntegrationTest
    test 'index' do
    	get currencies_path
    	assert_response :success
    end

    test 'create currencies' do
    	assert_difference('Currency.count', 3) do
    		post currencies_path
	    	assert_response :found
	    	assert_equal 'Currencies are succesfully created.', flash[:notice]
    	end
    end
end