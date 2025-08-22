class AlbumsController < ApplicationController
  def index
    @search_query = params[:search]
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @favorite_albums = user_signed_in? ? current_user.favorite_albums : []

    per_page = 20
    offset = (@page - 1) * per_page

    if @search_query.present?
      spotify_service = SpotifyApiService.new
      result = spotify_service.search_albums(@search_query, limit: per_page, offset: offset)

      @albums = result[:albums]
      @total_albums = result[:total]
      @total_pages = (@total_albums / per_page.to_f).ceil
    else
      @albums = []
      @total_albums = 0
      @total_pages = 0
    end
  end
end
