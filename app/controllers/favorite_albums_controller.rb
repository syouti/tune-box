class FavoriteAlbumsController < ApplicationController
  def index
    @favorite_albums = FavoriteAlbum.recent
  end

  def create
    @favorite_album = FavoriteAlbum.new(favorite_album_params)

    respond_to do |format|
      if @favorite_album.save
        format.json { render json: { status: 'added', message: 'コレクションに追加しました' } }
      else
        format.json { render json: { status: 'error', message: 'エラーが発生しました' } }
      end
    end
  end

  def destroy
    @favorite_album = FavoriteAlbum.find_by(spotify_id: params[:id])

    respond_to do |format|
      if @favorite_album&.destroy
        format.json { render json: { status: 'removed', message: 'コレクションから削除しました' } }
      else
        format.json { render json: { status: 'error', message: 'エラーが発生しました' } }
      end
    end
  end

  def toggle
    spotify_id = params[:spotify_id]
    existing_album = FavoriteAlbum.find_by(spotify_id: spotify_id)

    respond_to do |format|
      if existing_album
        # 既に存在する場合は削除
        existing_album.destroy
        format.json { render json: {
          status: 'removed',
          message: 'コレクションから削除しました',
          is_favorite: false
        } }
      else
        # 存在しない場合は追加（ただし20件制限）
        if FavoriteAlbum.count >= 20
          format.json { render json: {
            status: 'limit_exceeded',
            message: 'コレクションは20枚までです',
            is_favorite: false
          } }
        else
          favorite_album = FavoriteAlbum.create(favorite_album_params)
          if favorite_album.persisted?
            format.json { render json: {
              status: 'added',
              message: 'コレクションに追加しました',
              is_favorite: true
            } }
          else
            format.json { render json: {
              status: 'error',
              message: 'エラーが発生しました',
              is_favorite: false
            } }
          end
        end
      end
    end
  end

  private

  def favorite_album_params
    params.require(:favorite_album).permit(:spotify_id, :name, :artist, :image_url, :external_url, :release_date, :total_tracks)
  end

  def update_layout
    layout_data = params[:layout]

    layout_data.each do |item|
      album = FavoriteAlbum.find(item[:id])
      album.update(
        position_x: item[:x],
        position_y: item[:y]
      )
    end

    render json: { status: 'success' }
  end
end
