require 'test_helper'
require 'json'

module CurrencyManager
	class CurrencyCreatorTest < ActiveJob::TestCase
		setup do
			@currency_creator = CurrencyManager::CurrencyCreator.new
		end

		context 'call' do
			should 'success' do
				Currency.delete_all
				response = { success: true, updated_or_created: true }

				assert_difference('Currency.count', 3) do
					assert_equal response, @currency_creator.call
				end
			end

			# should 'fail' do
			# 	stub_request(:get, @wrong_url).with(headers: @header).to_return(status: 'fail?', body: @failed_response.to_json)
			# 	response = { success: false, error_message: 103 }
			# 	assert_equal response, @currency_creator.call
			# end
		end

		test 'get_currencies_from_api' do
			assert_equal @successful_response, @currency_creator.get_currencies_from_api
		end

		test 'create_or_update_currencies' do
			Currency.delete_all
			
			# create
			assert_difference('Currency.count', 3) do
				assert @currency_creator.create_or_update_currencies(@successful_response['quotes'])
			end

			# update
			assert_no_difference('Currency.count') do
				assert @currency_creator.create_or_update_currencies(@successful_response['quotes'])
			end
		end
	end
end