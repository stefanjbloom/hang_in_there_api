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

    def self.missing_id(id)
        poster_hash = {}
        begin
            poster_hash[:status_code] = 200
            poster_var = Poster.find(id)
            poster_var = PosterSerializer.new(poster_var)
            poster_hash[:body] = poster_var
        rescue ActiveRecord::RecordNotFound
            poster_var = {
                "errors": [
                {
                "status": "404",
                "message": "Record not found"
                }
            ]} 
            poster_hash[:status_code] = 404
            poster_hash[:body] = poster_var
        end
        return poster_hash
    end

    def self.error_handle(params)
        poster_hash = {}
        poster_var = Poster.new(params)
        if poster_var.valid?
            poster_var.save
            poster_var = PosterSerializer.new(poster_var)
            poster_hash[:status_code] = 201
            poster_hash[:body] = poster_var
        else
            data_insert = poster_var.errors.full_messages()  
            poster_var = {
                "errors": [
                {
                "status": "422",
                "message": data_insert
                }
            ]} 
            poster_hash[:status_code] = 422
            poster_hash[:body] = poster_var
        end
        return poster_hash
    end
end
