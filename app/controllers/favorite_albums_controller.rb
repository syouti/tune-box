class FavoriteAlbumsController < ApplicationController
  before_action :require_login

  def index
    @favorite_albums = current_user.favorite_albums.order(:position)

    respond_to do |format|
      format.html
      format.json { render json: @favorite_albums }
    end
  end

  # キャンバス用のお気に入り操作（検索ページと同じ機能）
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

  # 位置保存機能
  def update_layout
    layout_data = params[:layout]

    layout_data.each do |item|
      favorite_album = current_user.favorite_albums.find(item[:id])
      favorite_album.update(
        position_x: item[:x],
        position_y: item[:y]
      )
    end

    render json: { status: 'success', message: 'レイアウトを保存しました' }
  rescue => e
    Rails.logger.error "Layout update error: #{e.message}"
    render json: { status: 'error', message: 'レイアウトの保存に失敗しました' }
  end

  # 個別削除
  def destroy
    favorite_album = current_user.favorite_albums.find_by(spotify_id: params[:id])

    if favorite_album&.destroy
      render json: { status: 'removed', message: 'アルバムを削除しました' }
    else
      render json: { status: 'error', message: '削除に失敗しました' }
    end
  end

  # 一括削除
  def bulk_destroy
    # 既存のコード
  end

  private

  def require_login
    unless current_user
      redirect_to login_path, alert: 'ログインが必要です'
    end
  end
end
