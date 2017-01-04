class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :remember_token, :activation_token, :reset_token

  enum unit_preference: { feet: 0, meters: 1 }, _prefix: :prefers

  has_many :activities, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :unit_preference, presence: true

  before_save :downcase_email
  before_create :create_activation_digest

  has_secure_password # BCrypt

  def full_name
    "#{first_name} #{last_name}"
  end

  # Saves/updates a remember token digest for a user's current persistent 
  # session, and a remember token for the current temporary session.
  def remember
    self.remember_token = self.class.new_token
    update_attributes(remember_digest: self.class.digest(remember_token))
  end

  # Returns true if given token matches the user's corresponding digest
  # attribute.
  def authenticated?(attr, token)
    digest = send("#{attr}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets user by deleting the server-side reference to a persistent session.
  def forget
    update_attributes(remember_digest: nil)
  end

  # Sends account activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Activates user's account.
  def activate
    update_attributes(activated: true, activated_at: Time.zone.now)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes(reset_digest: User.digest(reset_token),
                      reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a list of activities in the user's feed.
  def feed
    following_ids = "SELECT followed_id
                       FROM relationships
                      WHERE follower_id = :user_id"
    Activity.where("user_id IN (#{following_ids})", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def distance_unit
    case unit_preference
    when "feet" 
      "mi"
    when "meters"
      "km"
    end
  end

  def length_unit
    case unit_preference
    when "feet"
      "ft"
    when "meters"
      "m"
    end
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
