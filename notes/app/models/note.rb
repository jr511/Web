class Note < ApplicationRecord
  validates :title, presence: true
  validates :user, presence: true

  has_many :collection_notes, dependent: :destroy

  belongs_to :user
  
  has_attached_file :cover
  validates_attachment_content_type :cover, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
