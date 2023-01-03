class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  has_many :posts
  has_many :reactions
  has_one_attached :avatar

  has_many :relationships,
           ->(user) { RelationshipsQuery.where_in_relationship(user_id: user.id) },
           inverse_of: :user,
           dependent: :destroy,
           class_name: 'UserRelationship'

  has_many :friendships,
           ->(user) { RelationshipsQuery.where_in_relationship(user_id: user.id).where(status: 'friends') },
           inverse_of: :user,
           dependent: :destroy,
           class_name: 'UserRelationship'

  has_many :relations,
           ->(user) { UsersQuery.relations(user_id: user.id, scope: true) },
           through: :relationships,
           class_name: 'User',
           source: :friend

  has_many :friends,
           ->(user) { UsersQuery.relations(user_id: user.id, scope: true) },
           through: :friendships,
           class_name: 'User',
           source: :friend

  has_many :pending_requests,
           lambda { |user|
             RelationshipsQuery
               .where_in_relationship(user_id: user.id)
               .where(status: 'pending').where("(direction = '<-' AND user_id = ?) OR (direction = '->' AND friend_id = ?)", user.id, user.id)
           },
           inverse_of: :user,
           dependent: :destroy,
           class_name: 'UserRelationship'

  has_many :pending_requestors,
           ->(user) { UsersQuery.relations(user_id: user.id, scope: true) },
           through: :pending_requests,
           class_name: 'User',
           source: :friend

  has_many :friend_posts,
           through: :friends,
           class_name: 'Post',
           source: :posts

  def email_required?
    false
  end

  def find_relationship(other_user_id)
    if other_user_id < id
      relationships.where(user_id: other_user_id).first
    else
      relationships.where(friend_id: other_user_id).first
    end
  end

  def display_name
    return name unless name.blank?
    return username unless username.blank?
    return email unless email.blank?
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      user.username = auth.screen_name # assuming the user model has a username
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
end
