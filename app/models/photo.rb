class Photo < ApplicationRecord
  belongs_to :location
  mount_uploader :image, AvatarUploader
end
