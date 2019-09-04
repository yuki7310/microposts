class Message < ApplicationRecord
  belongs_to :user
  belongs_to :talk
  validates :user_id, presence: true
  validates :talk_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  
end
