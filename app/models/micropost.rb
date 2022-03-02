class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
                size: { less_than: 5.megabytes, message: "should be less than 5MB" }
            


  def scanLink(text)
    html_text = text.gsub(URI.regexp, '<a href="\0">\0</a>').html_safe
    return html_text
  end

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
  
end
