class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.all.filter_by_name(params[:name]).filter_by_max(params[:max_price]).filter_by_min(params[:min_price])
        options = {}
        options[:meta] = { count: posters.count}
        render json: PosterSerializer.new(posters, options)
    end
    
    def show
        poster = Poster.find(params[:id])
        options = {}
        options[:meta] = { count: 1}
        render json: PosterSerializer.new(poster, options)
    end

    def create
        poster = Poster.create(poster_params)
        options = {}
        options[:meta] = { count: 1}
        render json: PosterSerializer.new(poster, options), status: 201
    end

    def update
        poster = Poster.update(params[:id], poster_params)
        options = {}
        options[:meta] = { count: 1}
        render json: PosterSerializer.new(poster, options)
    end

    def destroy
        render json: Poster.delete(params[:id]), status: 204
    end

    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end