require 'test_helper'

class CurrenciesIntegrationTest < ActionDispatch::IntegrationTest
	test 'index' do
		get currencies_path
		assert_response :success
	end
end