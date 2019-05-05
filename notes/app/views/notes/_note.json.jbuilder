json.extract! note, :id, :title, :content, :image, :user_id, :shared, :created_at, :updated_at
json.url note_url(note, format: :json)
