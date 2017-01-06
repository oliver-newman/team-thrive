class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :remember_token, :strava_token

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

  validates :strava_token, presence: true
  validates :strava_id, presence: true
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :unit_preference, presence: true

  before_save :downcase_email

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

  # Returns a Strava API client using the user's Strava access token.
  def strava_client
    @strava_client ||= Strava::Api::V3::Client.new(access_token: strava_token)
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

    # Finds or creates user using data from linked Strava account.
    def from_strava(strava_response)
      strava_athlete = strava_response["athlete"]
      find_or_create_by(strava_id: strava_athlete["id"]) do |user|
        user.strava_token    = strava_response["access_token"]
        user.first_name      = strava_athlete["firstname"]
        user.last_name       = strava_athlete["lastname"]
        user.email           = strava_athlete["email"]
        user.unit_preference = strava_athlete["measurement_preference"]
      end
    end
  end

  private

  # Converts email to all lower-case.
  def downcase_email
   email.downcase!
  end
end
