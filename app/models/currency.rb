class Currency < ApplicationRecord
	DEFAULT_FROM 	   = 'USD'
	ALLOWED_CURRENCIES = ['USD', 'EUR', 'CHF']
	
	default_scope -> { where(name: ALLOWED_CURRENCIES) }

	def update_currency_rate(new_rate)
		update_columns(rate: new_rate) if rate != new_rate
	end
end
