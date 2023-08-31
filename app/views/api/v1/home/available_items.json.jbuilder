json.array! @items do |item|
  json.title item.title
  json.author item.author
  json.code item.code
  json.image_path asset_path(item.image_path)
  json.description item.description
end
