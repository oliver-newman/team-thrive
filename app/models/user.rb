class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :remember_token, :activation_token

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password # BCrypt

  before_save :downcase_email
  before_create :create_activation_digest

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
  def authenticated?(attr, token)
    digest = send("#{attr}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets user by deleting the server-side reference to a persistent session.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Sends account activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Activates user's account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  class << self
    # Returns hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  # Converts email to all lower-case.
  def downcase_email
   email.downcase!
  end

  # Creates and assigns activation token and digest for user.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
