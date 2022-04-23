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
			redirect_to currencies_path, notice: 'Successfully created'
		else
			redirect_to currencies_path, alert: 'Currencies could not be created!'
		end
	end

	def fetch_data
		if @success
			redirect_to currencies_path, notice: 'Successfully updated'
		else
			redirect_to currencies_path, alert: 'Currencies are already up to date'
		end
	end

	private

	def fetch_currencies
		currency_creator = ::CurrencyManager::CurrencyCreator.new
		result 		 	 = currency_creator.call
		@success 		 = result[:success] && result[:updated_or_created]
		unless result[:success]
			return redirect_to currencies_path, alert: result[:error_message]
		end
	end
end
