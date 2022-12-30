module UsersHelper
  def relation_setting(user, other_user_id)
    return 'self' if user.id == other_user_id
    return 'none' unless relationship = user.find_relationship(other_user_id)

    if relationship.status == 'pending' && relationship.requestee?(user.id)
      'pending me'
    elsif relationship.status == 'pending'
      'pending other'
    else
      relationship.status
    end
  end
end
