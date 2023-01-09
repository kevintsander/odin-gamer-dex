class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :delete_all
  has_many_attached :images

  validates :body, length: { minimum: 0, maximum: 4000 }, allow_blank: false
  validates :body, presence: true, if: :no_images?
  validates :images,
            content_type: { in: ['image/png', 'image/jpeg', 'image/webp'],
                            message: 'must be .png, .jpg, or .webp' },
            size: { less_than: 5.megabytes,
                    message: 'must be less than 5 megabytes' },
            limit: { max: 10,
                     message: 'count maximum is 10' }

  def no_images?
    !images || !images.attached?
  end
end
