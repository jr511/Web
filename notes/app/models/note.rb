class Note < ApplicationRecord
  belongs_to :user
  
  has_attached_file :cover, styles: { medium: "1280x720", thumb:"800x600"}
end
