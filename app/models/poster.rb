class Poster < ApplicationRecord
    scope :filter_by_name, ->(name = nil) { name.present? ? where("name ILIKE ?", "%#{name}%") : all }
    scope :filter_by_max, ->(price = nil) { price.present? ? where("price <= ?", price) : all}
    scope :filter_by_min, ->(price = nil) { price.present? ? where("price >= ?", price) : all }
 
    def self.order_by(sort)
        sort.present? ? order(created_at: sort) : all   
    end
end