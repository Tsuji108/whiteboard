class Reservation < ApplicationRecord
  belongs_to :user

  validates :band_name, presence: true, length: { maximum: 20 }
end
