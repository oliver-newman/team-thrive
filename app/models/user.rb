class User < ApplicationRecord
  attr_accessor :remember_token

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password # BCrypt
  validates :password, presence: true, length: { minimum: 6 }

  before_save { email.downcase! }

  def full_name
    "#{first_name} #{last_name}"
  end

  # Returns hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token for persistent cookies.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = new_token
    update_attribute(:remember_digest, digest(remember_token))
  end
end
