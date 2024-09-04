class Api::V1::PostersController < ApplicationController
    def index
        render json: Poster.all
    end
end