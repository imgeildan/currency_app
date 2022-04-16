require 'json'
require 'net/http'
require 'uri'
require 'money/bank/currencylayer_bank'

class CurrenciesController < ActionController::Base
	def index
		@currencies 	= Currency.all
		@currency_names = Currency.all.pluck(:name)
		currency_from 	= params[:currency_from] || Currency::DEFAULT_FROM
		currency_to   	= params[:currency_to]   || 'EUR'

		if params[:value].present? && currency_from.present? && currency_to.present?
			result = (params[:value].to_i / Currency.find_by(name: currency_from).rate) * Currency.find_by(name: currency_to).rate
			@converted_number = result.round(4)
		end
	end

	def fetch_data
   	   	@uri 		= URI.parse("http://api.currencylayer.com/live?currencies=#{Currency::ALLOWED_CURRENCIES.join(',')}&access_key=77be030543cbf4d5f6303e84cf9a3a4a")
		request 	= Net::HTTP::Get.new(@uri)
		req_options = {  use_ssl: @uri.scheme == 'https' }
		response 	= Net::HTTP.start(@uri.hostname, @uri.port, req_options) do |http|
		    http.request(request)
		end

		parsed_response = JSON.parse(response.body)
		if parsed_response['success']
			parsed_response['quotes'].each do |quote|
				name = quote.first[3..6] # 'USDEUR' --> 'EUR'
				rate = quote.second
				currency = Currency.find_by(name: name)
				if currency.present?
					currency.update_currency(rate)
				else
					Currency.create!(name: name, rate: rate)
				end
			end
		else

		end

		redirect_to currencies_path
	end
end
