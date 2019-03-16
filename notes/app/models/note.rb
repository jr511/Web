class Note < ApplicationRecord
  belongs_to :user
  
  has_attached_file :cover
  validates_attachment_content_type :cover, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
