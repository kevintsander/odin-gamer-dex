module RelationshipsQuery
  extend self

  def where_in_relationship(user_id:)
    # unscope is only needed when coming through the User model has_many
    # association which will automatically add a where clause
    relationships.unscope(where: :user_id)
                 .where(user_id:)
                 .or(relationships.where(friend_id: user_id))
  end

  private

  def relationships
    @relationships ||= UserRelationship.all
  end
end
