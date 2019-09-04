class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  validates :user_id, uniqueness: { scope: :talk_id }
  
end
