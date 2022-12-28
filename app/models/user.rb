class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  has_many :posts
  has_one_attached :avatar

  has_many :user_relationships
  has_many :relations, through: :user_relationships, source: :friend

  scope :friends, -> { relations.where(status: 'accepted') }

  def email_required?
    false
  end

  def find_relationship_status(other_user)
    relationship = user_relationships.find_by(friend_id: other_user.id)
    return 'none' unless relationship

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
