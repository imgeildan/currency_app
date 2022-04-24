require 'test_helper'
require 'json'

class CurrencyFetcherJobTest < ActiveJob::TestCase
	test 'perform' do
		response = { success: true, updated_or_created: true }
		assert_equal response, CurrencyFetcherJob.perform
	end
end