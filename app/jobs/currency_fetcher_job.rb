class CurrencyFetcherJob
	@queue = :default

	def self.perform
		response = get_currencies_from_api
		if response['success']
			create_or_update_currencies(response['quotes'])
			DataCache.del('error_message')
		else
			DataCache.set 'error_message', response['error']['info']
		end
	end

	def self.get_currencies_from_api
	begin
		api_url  		   = 'http://api.currencylayer.com/live'
		allowed_currencies = Currency::ALLOWED_CURRENCIES.join(',')
		access_key         = Rails.application.credentials.money[:access_key]
		url				   = "#{api_url}?currencies=#{allowed_currencies}&access_key=#{access_key}"
		uri 			   = URI.parse(url)
		request 		   = Net::HTTP::Get.new(uri)
		response 		   = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(request) }
		response           = JSON.parse(response.body)
	rescue URI::InvalidURIError => error
	    bad_uri = error.message.match(/^bad\sURI\(is\snot\sURI\?\)\:\s(.*)$/)[1]
		good_uri = URI.encode bad_uri
		response = self.unshorten good_uri
    end
    	response
	end

	def self.create_or_update_currencies(currencies_hash)
		currencies_hash.each do |curr_name, curr_rate|
			name 	 = curr_name[3..6] # 'USDEUR' --> 'EUR'
			currency = Currency.find_by(name: name)
			if currency.present?
				if curr_rate != currency.rate
					currency.update(rate: curr_rate) 
				end
			else
				Currency.create!(name: name, rate: curr_rate)
			end
		end
		DataCache.set 'currency_count', Currency.count
	end
end