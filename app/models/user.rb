class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search(param)
    param.strip!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    
    return nil unless to_send_back

    to_send_back
  end

  def self.first_name_matches(param)
    find_friend('first_name', param)
  end

  def self.last_name_matches(param)
    find_friend('last_name', param)
  end

  def self.email_matches(param)
    find_friend('email', param)
  end

  def self.find_friend(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end     

  def under_stock_limit?
    stocks.count < 10
  end

  def stock_already_tracked?(ticker)
    stock = Stock.check_ticker_exists(ticker)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def can_track_stock?(ticker)
    under_stock_limit? && !stock_already_tracked?(ticker)
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(friend_id)
    !self.friends.where(id: friend_id).exists?
  end
end
