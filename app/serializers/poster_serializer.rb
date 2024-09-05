class PosterSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :price, :year, :vintage, :img_url
end
