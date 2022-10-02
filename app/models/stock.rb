class Stock < ApplicationRecord
	has_many :user_stocks
	has_many :users, through: :user_stocks

	validates :name, :ticker, presence: true

	def self.new_lookup(ticker)
		client = IEX::Api::Client.new(
  	publishable_token: ENV["IEX_CLOUD_KEY"],
  	secret_token: ENV["IEX_CLOUD_SECRET"],
  	endpoint: 'https://cloud.iexapis.com/v1'
		)
		begin
			new(ticker: ticker, name: client.company(ticker).company_name, last_price: client.quote(ticker).latest_price)
		rescue => exception
			return nil
		end
	end

	def self.check_ticker_exists(ticker)
		where(ticker: ticker).first
	end
end
