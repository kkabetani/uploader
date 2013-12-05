json.array!(@contents) do |content|
  json.extract! content, :upload_file_name, :upload_file
  json.url content_url(content, format: :json)
end
