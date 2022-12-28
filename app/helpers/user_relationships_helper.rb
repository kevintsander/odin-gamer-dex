module UserRelationshipsHelper
  def status_text(status)
    case status
    when 'pending'
      'Pending'
    when 'accepted'
      'Friends'
    else
      ''
    end
  end
end
