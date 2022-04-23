class Currency < ApplicationRecord
	ALLOWED_CURRENCIES = %w[USD EUR CHF]

	default_scope -> { where(name: ALLOWED_CURRENCIES) }

	validates :name, presence: true
	validates :rate, presence: true, numericality: true

	def self.convert(value, currency_from, currency_to)
		if value.present? && currency_from.present? && currency_to.present?
			result = (value.to_i / Currency.find_by(name: currency_from).rate) * Currency.find_by(name: currency_to).rate
			return result.round(4)
		end
	end
end
