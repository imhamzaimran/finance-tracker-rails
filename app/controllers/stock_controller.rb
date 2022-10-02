class StockController < ApplicationController
	def search
		if params[:stock].present?
			@stock = Stock.new_lookup(params[:stock].upcase)
			if @stock
				respond_to do |format|
					format.js { render partial: 'users/result' }
				end
			else
				flash_and_to_respond
			end
		else
			flash_and_to_respond
		end
	end

	private
	def flash_and_to_respond
		respond_to do |format|
			flash.now[:alert] = "Please enter a valid symbol to search"
			format.js { render partial: 'users/result' }
		end
	end
end
