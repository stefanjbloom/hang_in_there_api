class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end

    def show
        render json: Poster.find(params[:id])
    end

    def destroy
        render json: Poster.delete(params[:id])
    end
end