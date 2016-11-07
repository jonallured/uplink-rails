class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  has_many :subscriptions

  before_validation :set_token
  validates_presence_of :token

  def hooks
    subscriptions.map(&:hooks).flatten
  end

  private

  def set_token
    while self.token == nil || self.token.empty? do
      hex_token = SecureRandom.hex(32).upcase
      self.token = hex_token unless self.class.exists? token: hex_token
    end
  end
end
