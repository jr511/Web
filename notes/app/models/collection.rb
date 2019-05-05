class Collection < ActiveRecord::Base

  validates :title, presence: true
  validates :user, presence: true

  has_many :collection_notes, dependent: :destroy

  belongs_to :user

end

