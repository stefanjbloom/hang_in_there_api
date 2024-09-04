class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end

    def create
        render json: Poster.create(poster_params)
    end

    def show
        render json: Poster.find(params[:id])
    end

    def destroy
        render json: Poster.delete(params[:id])
    end
    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end