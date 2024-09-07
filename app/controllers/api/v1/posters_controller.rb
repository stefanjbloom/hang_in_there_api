class Api::V1::PostersController < ApplicationController
    def index
        posters = Poster.order_by(params[:sort])
                        .filter_by_name(params[:name])
                        .filter_by_max(params[:max_price])
                        .filter_by_min(params[:min_price])


        options = {}
        options[:meta] = { count: posters.count}
        render json: PosterSerializer.new(posters, options)
    end
    
    def show
        poster = Poster.missing_id(params[:id])
        render json: poster[:body], status: poster[:status_code]
    end

    def create
        poster = Poster.error_handle(poster_params)
        render json: poster[:body], status: poster[:status_code]
    end

    def update
        poster = Poster.error_handle(poster_params, params[:id])
        render json: poster[:body], status: poster[:status_code]
    end

    def destroy
        render json: Poster.delete(params[:id]), status: 204
    end

    private

    def poster_params
        params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
    end
end