class CurrencyFetcherJob
	@queue = :default

	def self.perform
		response = get_currencies_from_api
		create_or_update_currencies(response['quotes']) if parsed_response['success']
	end

	def self.get_currencies_from_api
		api_url  		   = 'http://api.currencylayer.com/live'
		allowed_currencies = Currency::ALLOWED_CURRENCIES.join(',')
		access_key         = Rails.application.credentials.money[:access_key]
		url				   = "#{api_url}?currencies=#{allowed_currencies}&access_key=#{access_key}"
		uri 			   = URI.parse(url)
		request 		   = Net::HTTP::Get.new(uri)
		response 		   = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
		JSON.parse(response.body)
	end

	def self.create_or_update_currencies(currencies_hash)
		currencies_hash.each do |curr_name, curr_rate|
			name 	 = curr_name[3..6] # 'USDEUR' --> 'EUR'
			currency = Currency.find_by(name: name)
			if currency.present?
				currency.update(rate: curr_rate) if curr_rate != currency.rate
			else
				Currency.create!(name: name, rate: curr_rate)
			end
		end
	end
end