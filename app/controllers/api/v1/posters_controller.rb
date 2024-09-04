class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end

    def show
        render json: Poster.find(params[:id])
    end
end