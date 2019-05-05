class CollectionNote < ApplicationRecord

  validates :collection, presence: true
  validates :note, presence: true, uniqueness: { scope: :collection }

  belongs_to :collection
  belongs_to :note
end
