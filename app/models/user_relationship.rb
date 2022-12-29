class UserRelationship < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  scope :is_friendship, -> { where(status: 'friend') }

  def requestee?(check_user_id)
    if direction == '->' && friend_id == check_user_id.to_i
      true
    elsif direction == '<-' && user_id == check_user_id.to_i
      true
    else
      false
    end
  end

  def self.get_direction(requestor_id, requestee_id)
    if requestor_id < requestee_id
      '->'
    elsif requestor_id > requestee_id
      '<-'
    end
  end
end
