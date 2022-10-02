class UserStocksController < ApplicationController
	def create
		stock = Stock.check_ticker_exists(params[:ticker])
		if stock.blank?
			stock = Stock.new_lookup(params[:ticker])
			stock.save
		end
		@user_stock = UserStock.create(user: current_user, stock: stock)
		flash[:notice] = "Stock #{stock.name} was addded to you portfolio"
		redirect_to my_portfolio_path
	end

	def destroy
		stock = Stock.find(params[:id])
		current_user.stocks.delete(stock)

		flash[:notice] = "#{stock.name} stock was successfully removed from you portfolio"
		redirect_to my_portfolio_path
	end
end
