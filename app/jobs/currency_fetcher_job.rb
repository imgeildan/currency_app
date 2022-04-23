class CurrencyFetcherJob
	@queue = :default

	def self.perform
		currency_creator = ::CurrencyManager::CurrencyCreator.new
		currency_creator.call
	end
end