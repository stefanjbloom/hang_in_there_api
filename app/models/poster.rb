class Poster < ApplicationRecord
    scope :filter_by_name, ->(name = "") { where("name ILIKE ?", "%#{name}%") }
    scope :filter_by_max, ->(price = 0) { where("price >= ?", price) }
    scope :filter_by_min, ->(price = 0) { where("price <= ?", price) }
end