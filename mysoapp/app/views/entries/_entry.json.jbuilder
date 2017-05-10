json.extract! entry, :id, :text, :user_id, :likes, :created_at, :updated_at
json.url entry_url(entry, format: :json)
