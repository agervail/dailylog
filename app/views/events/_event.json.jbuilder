json.extract! event, :id, :EventType, :date, :created_at, :updated_at
json.url event_url(event, format: :json)
