class Photo < ApplicationRecord
  belongs_to :listing
  has_one_attached :file

  def image_as_thumbnail
    image.variant(resize_to_limit: [300, 300]).processed
  end
end
