require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
	test 'constant ALLOWED_CURRENCIES' do
		assert_equal %w[USD EUR CHF], Currency::ALLOWED_CURRENCIES
	end

	context 'validations' do
		should validate_presence_of(:name)
		should validate_presence_of(:rate)
		should validate_uniqueness_of(:name)
		should validate_numericality_of(:rate)
	end

	test 'default_scope' do
		unscoped_currency = Currency.create(name: 'unscoped_currency', rate: '3.5')
		assert_not_includes Currency.all, unscoped_currency
	end

	test 'rate should be numeric value' do
		usd = currencies(:usd)
		assert_not usd.update(rate: 'string')
		usd.reload
		assert_equal 1.0, usd.rate

		usd.update(rate: 4.0)
		assert_equal 4.0, usd.rate
	end

	test 'convert' do
		assert_equal 92.6031,  Currency.convert(100, 'USD', 'EUR')
		assert_equal 107.9877, Currency.convert(100, 'EUR', 'USD')
		assert_equal 101.989,  Currency.convert(100, 'EUR', 'CHF')
	end
end