class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  has_many :posts
  has_one_attached :avatar

  has_many :relationships,
           ->(user) { RelationshipsQuery.bidirectional(user_id: user.id) },
           inverse_of: :user,
           dependent: :destroy,
           class_name: 'UserRelationship'

  has_many :relations,
           ->(user) { UsersQuery.relations(user_id: user.id, scope: true) },
           through: :relationships,
           class_name: 'User',
           source: :friend

  def email_required?
    false
  end

  def find_relationship(other_user)
    relationships.where(user_id: other_user.id).or(relationships.where(friend_id: other_user.id)).first
  end

  def relationship_status(other_user)
    return 'self' if other_user.id == id

    return 'none' unless relationship = find_relationship(other_user)

    relationship.status
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
