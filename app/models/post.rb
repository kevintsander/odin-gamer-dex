class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions
  has_many_attached :images
end
