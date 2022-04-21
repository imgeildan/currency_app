class CurrencyFetcherJob
	@queue = :default

	def self.perform
		api_url  		   = 'http://api.currencylayer.com/live'
		allowed_currencies = Currency::ALLOWED_CURRENCIES.join(',')
		access_key         = Rails.application.credentials.money[:access_key]
		url				   = "#{api_url}?currencies=#{allowed_currencies}&access_key=#{access_key}"
		uri 			   = URI.parse(url)
		request 		   = Net::HTTP::Get.new(uri)
		response 		   = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
		parsed_response    = JSON.parse(response.body)
		currencies_hash	   = parsed_response['quotes']

		if parsed_response['success']
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
end