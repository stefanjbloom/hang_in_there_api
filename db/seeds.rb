# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
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