require 'rails_helper'

describe "Posters API" do
    it "sends a list of posters" do
        Poster.create(name: "REGRET",
            description: "Hard work rarely pays off.",
            price: 89.00,
            year: 2018,
            vintage: true,
            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d")

        Poster.create(name: "FAILURE",
            description: "Why bother trying? It's probably not worth it.",
            price: 68.00,
            year: 2019,
            vintage: true,
            img_url: "https://images.unsplash.com/photo-1620401537439-98e94c004b0d")

        Poster.create(name: "MEDIOCRITY",
            description: "Dreams are just that—dreams.",
            price: 127.00,
            year: 2021,
            vintage: false,
            img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8")
        
        
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
end