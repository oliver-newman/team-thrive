class Activity < ApplicationRecord
  default_scope -> { order(start_date: :desc) }

  enum sport: { walk: 2, run: 0, ride: 1 }

  belongs_to :user

  has_attached_file :small_map
  has_attached_file :large_map

  validates :user_id, presence: true
  validates :strava_activity_id, presence: true
  validates :sport, presence: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :start_date, presence: true
  validates :distance, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }
  validates :elevation_gain, presence: true,
                             numericality: { greater_than_or_equal_to: 0 }
  validates :moving_time, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates_attachment :small_map, content_type: {
                                     content_type: /\Aimage\/.*\z/
                                   }
  validates_attachment :large_map, content_type: {
                                     content_type: /\Aimage\/.*\z/
                                   }
end
