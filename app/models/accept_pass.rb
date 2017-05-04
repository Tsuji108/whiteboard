class AcceptPass < ApplicationRecord
  belongs_to :user

  validates :accept_pass, presence: true, length: { minimum: 4, maximum: 50 }
end
