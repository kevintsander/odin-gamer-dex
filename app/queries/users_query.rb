module UsersQuery
  extend self

  def relations(user_id:, scope: false)
    query = relation.joins(sql(scope:)).where.not(id: user_id)

    query.where(user_relationships: { user_id: })
         .or(query.where(user_relationships: { friend_id: user_id }))

    # p query
  end

  private

  def relation
    @relation ||= User.all
  end

  # if coming through the User model has_many scope,
  # will automatically add an inner join so set scope to true
  # to ensure only necessary code is added
  def sql(scope: false)
    if scope
      <<~SQL
        OR users.id = user_relationships.user_id
      SQL
    else
      <<~SQL
        INNER JOIN user_relationships
          ON users.id = user_relationships.friend_id
          OR users.id = user_relationships.user_id
      SQL
    end
  end
end
