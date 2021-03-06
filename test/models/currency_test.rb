require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
	test 'constant ALLOWED_CURRENCIES' do
		assert_equal %w[USD EUR CHF], Currency::ALLOWED_CURRENCIES
	end

	test 'default_scope' do
		assert_no_difference('Currency.count') do
			Currency.create(name: 'unscoped_currency', rate: '3.5')	
		end
		unscoped_currency = Currency.find_by(name: 'unscoped_currency', rate: '3.5')
		assert_nil unscoped_currency
	end

	context 'validations' do
		should validate_presence_of(:name)
		should validate_presence_of(:rate)
		should validate_uniqueness_of(:name)
		should validate_numericality_of(:rate)
	end

	test 'rate should be numeric value' do
		usd = currencies(:usd)
		assert_not usd.update(rate: 'string')
		usd.reload
		assert_equal 1.0, usd.rate

		usd.update(rate: 4.0)
		assert_equal 4.0, usd.rate
	end

	context 'class methods' do
		should 'convert' do
			assert_equal 92.6031,  Currency.convert(100, 'USD', 'EUR')
			assert_equal 107.9877, Currency.convert(100, 'EUR', 'USD')
			assert_equal 101.989,  Currency.convert(100, 'EUR', 'CHF')
		end

		should 'update_or_create' do
			updated = Currency.update_or_create(name: 'EUR', rate: 3.0)
			assert updated
			assert_equal 3.0, currencies(:eur).rate
		end

		should 'assign_or_new' do
			new_currency = Currency.assign_or_new(name: 'new_currency', rate: 8.0)
			assert_equal 'new_currency', new_currency.name
			assert_equal 8.0, new_currency.rate
		end
	end
end