require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
    test 'constant ALLOWED_CURRENCIES' do
    	assert_equal %w[USD EUR CHF], Currency::ALLOWED_CURRENCIES
    end
end