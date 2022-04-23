require 'json'
require 'net/http'
require 'uri'

class CurrenciesController < ActionController::Base
	before_action :fetch_currencies, except: %i[index]

	def index
		@currencies 	  = Currency.all
		@currency_names   = Currency.all.pluck(:name)
		@converted_number = Currency.convert(params[:value], 
								  			 params[:currency_from], 
								  			 params[:currency_to])
	end

	def create
		if @success
			return redirect_to currencies_path, notice: 'Successfully created'
		else
			return redirect_to currencies_path, alert: 'could not be created!'
		end
	end

	def fetch_data
		if @success
			return redirect_to currencies_path, notice: 'Successfully updated'
		else
			return redirect_to currencies_path, alert: 'Up to date'
		end
	end

	private

	def fetch_currencies
		@error_message  = DataCache.get('error_message')
		@currency_count = DataCache.get_i('currency_count')
		@success = Resque.enqueue(CurrencyFetcherJob) && !@error_message && @currency_count.positive?
		sleep(5)
		return redirect_to currencies_path, alert: @error_message if @error_message
	end
end
