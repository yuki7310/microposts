class Talk < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, class_name: "User", through: :memberships, source: :user
  has_many :messages, dependent: :destroy
  default_scope -> { order(updated_at: :desc) }
  
  def to_user(current_user)
    members.select{ |member| current_user != member }.first
  end
  
  def latest_message
    messages.last if messages.count > 0
  end

end
