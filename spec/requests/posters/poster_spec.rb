require 'rails_helper'

describe "Posters API" do
    before(:all) do
        Rails.application.load_seed
    end

    it "sends a list of posters" do        
        get '/api/v1/posters'

        expect(response).to be_successful

        posters = JSON.parse(response.body, symbolize_names: true)

        expect(posters.count).to eq(3)

        posters.each do |poster|
            expect(poster).to have_key(:id)
            expect(poster[:id]).to be_an(Integer)

            expect(poster).to have_key(:name)
            expect(poster[:name]).to be_a(String)

            expect(poster).to have_key(:description)
            expect(poster[:description]).to be_a(String)

            expect(poster).to have_key(:price)
            expect(poster[:price]).to be_a(Float)

            expect(poster).to have_key(:year)
            expect(poster[:year]).to be_a(Integer)

            expect(poster).to have_key(:img_url)
            expect(poster[:img_url]).to be_a(String)
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

        expect(poster).to have_key(:id)
        expect(poster[:id]).to be_an(Integer)

        expect(poster).to have_key(:name)
        expect(poster[:name]).to be_a(String)

        expect(poster).to have_key(:description)
        expect(poster[:description]).to be_a(String)

        expect(poster).to have_key(:price)
        expect(poster[:price]).to be_a(Float)

        expect(poster).to have_key(:year)
        expect(poster[:year]).to be_a(Integer)

        expect(poster).to have_key(:img_url)
        expect(poster[:img_url]).to be_a(String)
    end    
end