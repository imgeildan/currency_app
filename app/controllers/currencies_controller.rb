require 'json'
require 'net/http'
require 'uri'

class CurrenciesController < ActionController::Base
	before_action :fetch_currencies, except: %i[index]

	def index
		@currencies 	= Currency.all
		@currency_names = Currency.all.pluck(:name)
		currency_from 	= params[:currency_from]
		currency_to   	= params[:currency_to]

		if params[:value].present? && currency_from.present? && currency_to.present?
			result = (params[:value].to_i / Currency.find_by(name: currency_from).rate) * Currency.find_by(name: currency_to).rate
			@converted_number = result.round(4)
		end

	end

	def create
		if @success && Currency.persisted?
			return redirect_to currencies_path, notice: 'Successfully created'
		else
			return redirect_to currencies_path, alert: 'could not be created!'
		end
	end

	def fetch_data
		if @success
			message = Currency.updated? ? 'Successfully updated' : 'Up to date'
			return redirect_to currencies_path, notice: message
		else
			return redirect_to currencies_path, alert: 'could not be updated!'
		end
	end

	private

	def fetch_currencies
		@success = Resque.enqueue(CurrencyFetcherJob)
		sleep(3)
	end
end
