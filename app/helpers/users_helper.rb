module UsersHelper
  def relation_setting(user, other_user)
    return 'self' if user.id == other_user.id
    return 'none' unless relationship = user.find_relationship(other_user)

    if relationship.status == 'pending' && relationship.requestee?(user.id)
      'pending me'
    elsif relationship.status == 'pending'
      'pending other'
    else
      relationship.status
    end
  end
end
