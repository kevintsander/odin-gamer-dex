class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :delete_all
  has_many_attached :images
end
