class Poster < ApplicationRecord
    validates :name, :description, :price, :year, :img_url, presence: {message: "is required"}
    validates :price, numericality: {message: "should be a valid price"} 
    validates :year, numericality: {only_integer: true, message: "should be a valid year"}
    validates :vintage, inclusion: { in:[true, false], message: "should be true or false" }
    validates :name, uniqueness: { message: "needs to be unique" }
    
    scope :filter_by_name, ->(name = nil) { name.present? ? where("name ILIKE ?", "%#{name}%") : all }
    scope :filter_by_max, ->(price = nil) { price.present? ? where("price <= ?", price) : all}
    scope :filter_by_min, ->(price = nil) { price.present? ? where("price >= ?", price) : all }
 
    def self.order_by(sort)
        sort.present? ? order(created_at: sort) : all   
    end
end