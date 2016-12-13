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

  # Saves/updates a remember token digest for a user's current persistent 
  # session, and a remember token for the current temporary session.
  def remember
    self.remember_token = self.class.new_token
    update_attribute(:remember_digest, self.class.digest(remember_token))
  end

  # Returns true if given token matches the user's current digest (i.e., if
  # the user's account is being accessed from the computer from which the user's
  # current peristent session was initiated).
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets user by deleting the server-side reference to a persistent session.
  def forget
    update_attribute(:remember_digest, nil)
  end

  class << self
    # Returns hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token for persistent cookies.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
