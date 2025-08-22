class FavoritesController < ApplicationController
  before_action :require_login

  # 検索ページ用：お気に入りの追加/削除のみ
  def toggle
    current_count = current_user.favorite_albums.count

    if params[:favorite_album]
      spotify_id = params[:favorite_album][:spotify_id]

      # 🆕 Spotify IDの検証
      if spotify_id.blank?
        render json: {
          status: 'error',
          message: 'Spotify IDが無効です'
        }
        return
      end

      existing_album = current_user.favorite_albums.find_by(spotify_id: spotify_id)

      if existing_album
        # 削除処理
        if existing_album.destroy
          render json: {
            status: 'removed',
            current_count: current_user.favorite_albums.count,
            message: 'コレクションから削除しました'
          }
        else
          render json: {
            status: 'error',
            message: '削除に失敗しました'
          }
        end
      else
        # 追加処理
        if current_count >= 25
          render json: {
            status: 'error',
            message: 'お気に入りは最大25個までです'
          }
          return
        end

        # 🆕 次の空いている位置を見つける
        position = find_next_available_position

        favorite_album = current_user.favorite_albums.build(params[:favorite_album].permit(
          :spotify_id, :name, :artist, :image_url, :external_url, :release_date, :total_tracks
        ))

        # 🆕 位置を設定
        favorite_album.position_x = position[:x]
        favorite_album.position_y = position[:y]

        if favorite_album.save
          render json: {
            status: 'added',
            current_count: current_user.favorite_albums.count,
            message: 'コレクションに追加しました',
            position: position,
            album: {
              id: favorite_album.id,
              name: favorite_album.name,
              artist: favorite_album.artist
            }
          }
        else
          render json: {
            status: 'error',
            message: '保存に失敗しました: ' + favorite_album.errors.full_messages.join(', ')
          }
        end
      end
    else
      render json: {
        status: 'error',
        message: 'データが不正です'
      }
    end

  rescue => e
    # 🆕 エラーハンドリングの追加
    Rails.logger.error "Favorites toggle error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    render json: {
      status: 'error',
      message: 'サーバーエラーが発生しました'
    }
  end

  private

  def require_login
    unless current_user
      # 🆕 AJAX リクエストの場合はJSONで返す
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'ログインが必要です' }
        format.json { render json: { status: 'error', message: 'ログインが必要です' }, status: 401 }
      end
    end
  end

  # 🆕 次の空いている位置を見つける関数
  def find_next_available_position
    occupied_positions = Set.new

    # 現在のアルバムの位置を収集
    current_user.favorite_albums.each do |album|
      if album.position_x.present? && album.position_y.present?
        grid_x = (album.position_x / 140).to_i
        grid_y = (album.position_y / 140).to_i
        occupied_positions.add("#{grid_x},#{grid_y}")
      end
    end

    Rails.logger.info "Occupied positions: #{occupied_positions.to_a}"

    # 空いている位置を探す（左上から右下へ）
    (0..4).each do |y|
      (0..4).each do |x|
        position_key = "#{x},#{y}"
        unless occupied_positions.include?(position_key)
          Rails.logger.info "Found available position: #{position_key}"
          return { x: x * 140, y: y * 140, grid_x: x, grid_y: y }
        end
      end
    end

    # 全て埋まっている場合は警告
    Rails.logger.warn "No available positions found, defaulting to (0,0)"
    { x: 0, y: 0, grid_x: 0, grid_y: 0 }
  end
end
