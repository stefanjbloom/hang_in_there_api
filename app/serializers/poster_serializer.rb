class PosterSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :price, :year, :img_url
end
