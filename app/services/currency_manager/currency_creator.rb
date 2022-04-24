module CurrencyManager
	class CurrencyCreator
		def call
			response = get_currencies_from_api

			if response['success'] 
				updated_or_created = create_or_update_currencies(response['quotes']) 
				return { success: true, updated_or_created: updated_or_created }
			end

			{ success: false, error_message: response['error']['info'] }
		end

		def get_currencies_from_api
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
				bad_uri  = error.message.match(/^bad\sURI\(is\snot\sURI\?\)\:\s(.*)$/)[1]
				good_uri = URI.encode bad_uri
				response = self.unshorten good_uri
			end
			response
		end

		def create_or_update_currencies(currencies_hash)
			currencies_hash.each do |name, rate|
				convert_to = name[3..6] # 'USDEUR' --> 'EUR'
				return false unless Currency.update_or_create(name: convert_to, rate: rate)
			end
			true
		end
	end
end