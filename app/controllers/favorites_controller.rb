class FavoritesController < ApplicationController
  before_action :require_login

  # 検索ページ用：お気に入りの追加/削除のみ
  def toggle
    current_count = current_user.favorite_albums.count

    if params[:favorite_album]
      spotify_id = params[:favorite_album][:spotify_id]
      existing_album = current_user.favorite_albums.find_by(spotify_id: spotify_id)

      if existing_album
        existing_album.destroy
        render json: {
          status: 'removed',
          current_count: current_user.favorite_albums.count
        }
      else
        if current_count >= 25
          render json: {
            status: 'error',
            message: 'お気に入りは最大25個までです'
          }
          return
        end

        favorite_album = current_user.favorite_albums.build(params[:favorite_album].permit(
          :spotify_id, :name, :artist, :image_url, :external_url, :release_date, :total_tracks
        ))

        if favorite_album.save
          render json: {
            status: 'added',
            current_count: current_user.favorite_albums.count
          }
        else
          render json: {
            status: 'error',
            message: '保存に失敗しました'
          }
        end
      end
    else
      render json: {
        status: 'error',
        message: 'データが不正です'
      }
    end
  end

  private

  def require_login
    unless current_user
      redirect_to login_path, alert: 'ログインが必要です'
    end
  end
end
