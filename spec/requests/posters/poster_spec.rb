require 'rails_helper'
require 'faker'

describe "Posters API" do
    before(:all) do
        Poster.destroy_all
        @saved_ids = []
        10.times do
            poster = Poster.create!(
                name: Faker::Company.buzzword,
                description: Faker::Company.bs,
                price: Faker::Number.decimal(l_digits: 2),
                year: Faker::Number.within(range: 1500..2020),
                vintage: Faker::Boolean.boolean(true_ratio: 0.4),
                img_url: "https://loremflickr.com/300/300"
            )
            @saved_ids.push(poster.id)
        end
    end

    it "sends a list of posters" do        
        get '/api/v1/posters'

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)

        expect(posters[:data].count).to eq(10)

        posters[:data].each do |poster|
            expect(poster).to have_key(:id)
            expect(poster[:id].to_i).to be_an(Integer)

            expect(poster).to have_key(:attributes)
            expect(poster[:attributes]).to be_a(Hash)

            expect(poster[:attributes]).to have_key(:name)
            expect(poster[:attributes][:name]).to be_a(String)

            expect(poster[:attributes]).to have_key(:description)
            expect(poster[:attributes][:description]).to be_a(String)

            expect(poster[:attributes]).to have_key(:price)
            expect(poster[:attributes][:price]).to be_a(Float)

            expect(poster[:attributes]).to have_key(:year)
            expect(poster[:attributes][:year]).to be_a(Integer)

            expect(poster[:attributes]).to have_key(:vintage)
            expect([true, false]).to include(poster[:attributes][:vintage])

            expect(poster[:attributes]).to have_key(:img_url)
            expect(poster[:attributes][:img_url]).to be_a(String)
        end
    end

    it "can get one poster by its id" do
        id = Poster.create(name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d").id
        
        get "/api/v1/posters/#{id}"
    
        poster = JSON.parse(response.body, symbolize_names: true)
    
        expect(response).to be_successful

        expect(poster[:data]).to have_key(:id)
        expect(poster[:data][:id].to_i).to be_an(Integer)

        expect(poster[:data][:attributes]).to have_key(:name)
        expect(poster[:data][:attributes][:name]).to be_a(String)

        expect(poster[:data][:attributes]).to have_key(:description)
        expect(poster[:data][:attributes][:description]).to be_a(String)

        expect(poster[:data][:attributes]).to have_key(:price)
        expect(poster[:data][:attributes][:price]).to be_a(Float)

        expect(poster[:data][:attributes]).to have_key(:year)
        expect(poster[:data][:attributes][:year]).to be_a(Integer)

        expect(poster[:data][:attributes]).to have_key(:vintage)
        expect([true, false]).to include(poster[:data][:attributes][:vintage])

        expect(poster[:data][:attributes]).to have_key(:img_url)
        expect(poster[:data][:attributes][:img_url]).to be_a(String)
    end    

    it "can destroy an poster" do
        poster = Poster.create(name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")
        
        expect(Poster.count).to eq(11)
    
        delete "/api/v1/posters/#{poster.id}"
    
        expect(response).to be_successful
        expect(Poster.count).to eq(10)
        expect{Poster.find(poster.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'can create a poster' do
        poster_params = {name: "JOY",
                description: "To the World, my program works!",
                price: 42.00,
                year: 2019,
                vintage: false,
                img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"}
        
        headers = { "CONTENT_TYPE" => "application/json" }

        post '/api/v1/posters', headers: headers, params: JSON.generate(poster: poster_params)
        created_poster = Poster.last

        expect(response).to be_successful

        poster = Poster.last
        expect(poster.name).to eq("JOY")
        expect(poster.description).to eq("To the World, my program works!")
        expect(poster.price).to eq(42.00)
        expect(poster.year).to eq(2019)
        expect(poster.vintage).to be false
        expect(poster.img_url).to eq("https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk")
    end

    it "can update an existing Poster" do
        id = Poster.create({name: "JOY",
            description: "To the World, my program works!",
            price: 42.00,
            year: 2019,
            vintage: false,
            img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"}).id
        previous_price = Poster.last.price
        poster_params = { price: 80.25 }
        headers = {"CONTENT_TYPE" => "application/json"}
        # We include this header to make sure that these params are passed as JSON rather than as plain text
        
        patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
        poster = Poster.find_by(id: id)
    
        expect(response).to be_successful
        expect(poster.price).to_not eq(previous_price)
        expect(poster.price).to eq(80.25)
    end

    it "can return posters in ascending order" do
        get "/api/v1/posters?sort=asc"
        poster = JSON.parse(response.body, symbolize_names: true)
        sorted_ids = poster[:data].map { |poster| poster[:id].to_i}
        
        expect(response).to be_successful
        expect(poster[:data].count).to eq(10)
        expect(sorted_ids).to eq(@saved_ids)
    end

    it "can return posters in descending order" do
        get "/api/v1/posters?sort=desc"
        
        poster = JSON.parse(response.body, symbolize_names: true)
        sorted_ids = poster[:data].map { |poster| poster[:id].to_i}
        desc_ids = @saved_ids.sort{ |a, b| b <=> a }
        expect(response).to be_successful
        expect(poster[:data].count).to eq(10)
        expect(sorted_ids).to eq(desc_ids)
    end

    it "can filter Posters by name" do
        get '/api/v1/posters?name=re'

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)

        posters[:data].each do |poster|
            expect(poster[:attributes]).to have_key(:name)
            expect(poster[:attributes][:name]).to be_a(String)
            expect(poster[:attributes][:name].downcase).to include("re".downcase)
        end
    end

    it "can filter Posters by max_price" do
        get '/api/v1/posters?max_price=88.00'

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)

        posters[:data].each do |poster|
            expect(poster[:attributes]).to have_key(:price)
            expect(poster[:attributes][:price]).to be_a(Float)
            expect(poster[:attributes][:price]).to be <= 88.00
        end
    end

    it "can filter Posters by min_price" do
        get '/api/v1/posters?min_price=88.00'

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)

        posters[:data].each do |poster|
            expect(poster[:attributes]).to have_key(:price)
            expect(poster[:attributes][:price]).to be_a(Float)
            expect(poster[:attributes][:price]).to be >= 88.00
        end
    end

    describe "errors" do

        it "will return a status code and message when incorrect id queried" do

            get '/api/v1/posters/74'
            
            expected = {
                errors: [
                {
                status: "404",
                message: "Record not found"
                }
            ]} 

            response_body = JSON.parse(response.body, symbolize_names: true)

            expect(response_body).to eq(expected)
        end

        it "will return a status code and message when required data is missing" do
            poster_params = {name: "FAILURE",
            price: 42.00,
            year: 2019,
            vintage: true,
            }
    
            headers = { "CONTENT_TYPE" => "application/json" }

            expected = {
                errors: [
                {
                status: "422",
                message: ["Description is required", "Img url is required", "Description cannot be blank", "Img url cannot be blank"]
                }
            ]} 

            post '/api/v1/posters', headers: headers, params: JSON.generate(poster: poster_params)

            response_body = JSON.parse(response.body, symbolize_names: true)

            expect(response_body).to eq(expected)
        end

        it "will return a status code and message when update is empty" do
            id = Poster.create({name: "JOY",
            description: "To the World, my program works!",
            price: 42.00,
            year: 2019,
            vintage: false,
            img_url: "https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"}).id
            previous_price = Poster.last.name
            poster_params = { name: "" }
            headers = {"CONTENT_TYPE" => "application/json"}
            expected = {
                errors: [
                {
                status: "422",
                message: ["Name is required", "Name cannot be blank"]
                }
            ]} 

            patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})

            response_body = JSON.parse(response.body, symbolize_names: true)

            expect(response_body).to eq(expected)
        end
    end
end

RSpec.describe Poster, type: :model do
    describe "validation" do
        it { should validate_presence_of(:name).with_message("is required")}
        it { should validate_presence_of(:description).with_message("is required")}
        it { should validate_presence_of(:img_url).with_message("is required")}
        it { should validate_presence_of(:price).with_message("is required")}
        it { should validate_presence_of(:year).with_message("is required")}
        it { should validate_numericality_of(:price).with_message("should be a valid price")}
        it { should validate_numericality_of(:year).with_message("should be a valid year")}
        it { should validate_inclusion_of(:vintage).in_array([true, false]).with_message("should be true or false")}
        it {should validate_uniqueness_of(:name).with_message("needs to be unique")}
    end

end