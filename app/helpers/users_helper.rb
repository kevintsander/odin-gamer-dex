module UsersHelper
  def relationship_image(user, relationship, size)
    case relationship_setting(user, relationship)
    when 'self'
      inline_svg_tag 'star.svg', class: 'stroke-amber-400 fill-amber-400',
                                 title: "Hey, it's you!",
                                 size:
    when 'pending me', 'pending other'
      inline_svg_tag 'question.svg', class: 'stroke-yellow-200',
                                     title: "Your friendship with #{user.display_name} is pending",
                                     size:
    when 'friends'
      inline_svg_tag 'friends.svg', class: 'stroke-lime-200 fill-lime-200',
                                    title: "You're friends with #{user.display_name}",
                                    size:
    end
  end
end

def relationship_setting(user, relationship)
  return 'self' if current_user.id == user.id
  return 'none' unless relationship && !relationship.destroyed?

  if relationship.status == 'pending' && relationship.requestee?(current_user.id)
    'pending me'
  elsif relationship.status == 'pending'
    'pending other'
  else
    relationship.status
  end
end
