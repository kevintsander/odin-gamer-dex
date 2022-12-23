class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[twitter]

  has_many :posts

  def email_required?
    false
  end

  def display_name
    p self
    puts "name #{name} email #{email} username #{username}"
    return name unless name.blank?
    return username unless username.blank?
    return email unless email.blank?
  end

  def self.from_omniauth(auth)
    p 'AUTH'
    p auth
    p 'AUTH INFO'
    p auth.info
    p 'AUTH EXTRA'
    p auth.extra
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      p auth.info
      user.email = auth.info.email
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
