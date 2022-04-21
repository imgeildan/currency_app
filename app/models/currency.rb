class Currency < ApplicationRecord
	ALLOWED_CURRENCIES = %w[USD EUR CHF]

	default_scope -> { where(name: ALLOWED_CURRENCIES) }

	def self.persisted?
		Currency.count.positive?
	end

	def self.updated?
		Currency.all.map { |c| c.previous_changes.empty? }.include?(false)
	end
end
