json.extract! collection, :id, :title, :user_id, :shared, :created_at, :updated_at
json.url note_url(collection, format: :json)
