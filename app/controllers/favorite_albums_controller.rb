# app/controllers/favorite_albums_controller.rb
class FavoriteAlbumsController < ApplicationController
  before_action :require_login
  before_action :require_confirmed_user

  def index
    start_time = Time.current
    @favorite_albums = current_user.favorite_albums.order(:created_at)

    # log_user_action('view_canvas', { album_count: @favorite_albums.count })
    # log_performance('canvas_load', ((Time.current - start_time) * 1000).round)

    respond_to do |format|
      format.html
      format.json { render json: @favorite_albums }
    end
  end

  # 🆕 検索ページからの追加/削除用のtoggleメソッド
  def toggle
    current_count = current_user.favorite_albums.count

    # パラメータのバリデーション
    unless params[:favorite_album]
      # log_error(StandardError.new('Missing favorite_album parameter'), { action: 'toggle' })
      render json: {
        status: 'error',
        message: 'データが不正です'
      }, status: 400
      return
    end

    spotify_id = sanitize_spotify_id(params[:favorite_album][:spotify_id])

    # Spotify IDの検証
    if spotify_id.blank? || !valid_spotify_id?(spotify_id)
      # log_error(StandardError.new('Invalid Spotify ID'), { action: 'toggle', spotify_id: spotify_id })
      render json: {
        status: 'error',
        message: 'Spotify IDが無効です'
      }, status: 400
      return
    end

    existing_album = current_user.favorite_albums.find_by(spotify_id: spotify_id)

    if existing_album
      # 削除処理
      if existing_album.destroy
        # log_user_action('remove_album', {
        #   album_id: existing_album.id,
        #   album_name: existing_album.name,
        #   current_count: current_user.favorite_albums.count
        # })
        render json: {
          status: 'removed',
          message: 'コレクションから削除しました',
          current_count: current_user.favorite_albums.count
        }
      else
        # log_error(existing_album.errors, { action: 'remove_album', album_id: existing_album.id })
        render json: {
          status: 'error',
          message: '削除に失敗しました'
        }, status: 422
      end
    else
      # 追加処理
      if current_count >= 25
        render json: {
          status: 'error',
          message: 'お気に入りは最大25個までです'
        }, status: 422
        return
      end

      # 次の空いている位置を見つける
      position = find_next_available_position

      # アルバムを作成（サニタイズ済みデータ）
      favorite_album = current_user.favorite_albums.build(
        spotify_id: spotify_id,
        name: sanitize_input(params[:favorite_album][:name]),
        artist: sanitize_input(params[:favorite_album][:artist]),
        image_url: sanitize_input(params[:favorite_album][:image_url]),
        external_url: sanitize_input(params[:favorite_album][:external_url]),
        release_date: sanitize_input(params[:favorite_album][:release_date]),
        total_tracks: params[:favorite_album][:total_tracks]&.to_i,
        position_x: position[:x],
        position_y: position[:y]
      )

      if favorite_album.save
        # log_user_action('add_album', {
        #   album_id: favorite_album.id,
        #   album_name: favorite_album.name,
        #   artist: favorite_album.artist,
        #   current_count: current_user.favorite_albums.count,
        #   position: position
        # })
        render json: {
          status: 'added',
          message: 'コレクションに追加しました',
          current_count: current_user.favorite_albums.count,
          position: position,
          album: {
            id: favorite_album.id,
            name: favorite_album.name,
            artist: favorite_album.artist
          }
        }
      else
        # log_error(favorite_album.errors, { action: 'add_album', spotify_id: spotify_id })
        render json: {
          status: 'error',
          message: '保存に失敗しました: ' + favorite_album.errors.full_messages.join(', ')
        }, status: 422
      end
    end

  rescue => e
    Rails.logger.error "Toggle error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")

    render json: {
      status: 'error',
      message: 'サーバーエラーが発生しました'
    }, status: 500
  end

  # 位置更新用のメソッド
  def update_layout
    layout_data = params[:layout]

    unless layout_data.is_a?(Array)
      render json: { status: 'error', message: 'レイアウトデータが無効です' }
      return
    end

    # 重複チェック用
    positions_used = Set.new
    errors = []

    ActiveRecord::Base.transaction do
      layout_data.each_with_index do |item, index|
        # データの存在チェック
        unless item[:id] && item[:x] && item[:y]
          errors << "アイテム#{index + 1}: 必須データが不足しています"
          next
        end

        # 範囲チェック
        x = item[:x].to_i
        y = item[:y].to_i

        # キャンバスサイズ: 700px x 742px (5x5グリッド)
        # より柔軟な範囲チェック（少し余裕を持たせる）
        if x < -50 || x > 610 || y < -50 || y > 642
          errors << "アイテム#{index + 1}: 座標が範囲外です (x:#{x}, y:#{y})"
          next
        end

        # 座標をキャンバス内に制限
        x = [0, [x, 560].min].max
        y = [0, [y, 592].min].max

        # 重複チェック
        grid_x = (x / 140).round
        grid_y = (y / 148).round
        position_key = "#{grid_x},#{grid_y}"

        if positions_used.include?(position_key)
          errors << "位置の重複が検出されました: #{position_key}"
          next
        end

        positions_used.add(position_key)

        # アルバム更新
        favorite_album = current_user.favorite_albums.find_by(id: item[:id])
        unless favorite_album
          errors << "アルバムID #{item[:id]} が見つかりません"
          next
        end

        unless favorite_album.update(position_x: x, position_y: y)
          errors << "アルバム#{favorite_album.name}の更新に失敗しました"
        end
      end

      # エラーがある場合はロールバック
      if errors.any?
        raise ActiveRecord::Rollback
      end
    end

    if errors.any?
      Rails.logger.error "Layout update errors: #{errors.join(', ')}"
      render json: {
        status: 'error',
        message: 'レイアウト更新中にエラーが発生しました',
        errors: errors
      }
    else
      Rails.logger.info "Layout updated successfully for #{layout_data.length} albums"
      render json: {
        status: 'success',
        message: 'レイアウトを保存しました',
        updated_count: layout_data.length
      }
    end

  rescue => e
    Rails.logger.error "Layout update exception: #{e.message}"
    render json: {
      status: 'error',
      message: 'レイアウトの保存に失敗しました'
    }
  end

  # 個別削除用
  def destroy
    favorite_album = current_user.favorite_albums.find_by(spotify_id: params[:id])

    if favorite_album&.destroy
      render json: {
        status: 'removed',
        message: 'アルバムを削除しました',
        current_count: current_user.favorite_albums.count
      }
    else
      render json: {
        status: 'error',
        message: '削除に失敗しました'
      }, status: 422
    end
  end

  # 一括削除用
  def bulk_destroy
    deleted_count = 0

    current_user.favorite_albums.each do |album|
      if album.destroy
        deleted_count += 1
      end
    end

    render json: {
      status: 'success',
      message: "#{deleted_count}枚のアルバムを削除しました",
      deleted_count: deleted_count,
      current_count: 0
    }

  rescue => e
    Rails.logger.error "Bulk delete error: #{e.message}"
    render json: {
      status: 'error',
      message: '一括削除中にエラーが発生しました'
    }, status: 500
  end

  # プレビュー用
  def preview_share_image
    begin
      Rails.logger.info "Starting preview generation request"

      # 画像生成サービスを呼び出し
      generator = ShareImageGenerator.new(current_user, current_user.favorite_albums)
      image_path = generator.generate

      Rails.logger.info "Preview generated successfully: #{image_path}"

      # Base64エンコードしてJSONで返す
      image_data = File.binread(image_path)
      base64_image = Base64.strict_encode64(image_data)

      render json: {
        status: 'success',
        image_data: "data:image/png;base64,#{base64_image}"
      }

    rescue => e
      Rails.logger.error "Preview generation error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: {
        status: 'error',
        message: "プレビュー生成に失敗しました: #{e.message}"
      }, status: 500
    ensure
                # 一時ファイルを削除（デバッグ中はコメントアウト）
                # if defined?(image_path) && image_path && File.exist?(image_path)
                #   File.delete(image_path)
                #   Rails.logger.info "Temporary preview file deleted: #{image_path}"
                # end
    end
  end

  # 画像生成用
  def generate_share_image
    image_path = nil
    begin
      Rails.logger.info "Starting image generation request"
      # 画像生成サービスを呼び出し
      generator = ShareImageGenerator.new(current_user, current_user.favorite_albums)
      image_path = generator.generate

      Rails.logger.info "Image generated successfully: #{image_path}"

      # 画像ファイルをレスポンスとして送信
      send_file image_path,
                type: 'image/png',
                disposition: 'attachment',
                filename: "tunebox_share_#{current_user.name}_#{Time.current.to_i}.png"

    rescue => e
      Rails.logger.error "Image generation error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: {
        status: 'error',
        message: "画像生成に失敗しました: #{e.message}"
      }, status: 500
    ensure
      # レスポンス送信後に一時ファイルを削除
      if image_path && File.exist?(image_path)
        # 少し遅延を入れてから削除
        Thread.new do
          sleep 1
          File.delete(image_path)
          Rails.logger.info "Temporary file deleted: #{image_path}"
        end
      end
    end
  end

  private

  # セキュリティ: Spotify IDのサニタイズ
  def sanitize_spotify_id(spotify_id)
    return nil if spotify_id.blank?
    spotify_id.to_s.strip.gsub(/[^a-zA-Z0-9]/, '')
  end

  # セキュリティ: Spotify IDの検証
  def valid_spotify_id?(spotify_id)
    spotify_id.present? && spotify_id.match?(/\A[a-zA-Z0-9]{22}\z/)
  end

  # セキュリティ: 入力値のサニタイズ
  def sanitize_input(value)
    return nil if value.blank?
    ActionController::Base.helpers.sanitize(value.to_s.strip, tags: [])
  end

  def require_login
    unless current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'ログインが必要です' }
        format.json { render json: { status: 'error', message: 'ログインが必要です' }, status: 401 }
      end
    end
  end

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

# app/controllers/favorites_controller.rb (必要に応じて)
class FavoritesController < ApplicationController
  before_action :require_login

  # 検索ページ用：お気に入りの追加/削除のみ（簡易版）
  def toggle
    # FavoriteAlbumsController#toggle にリダイレクト
    redirect_to action: :toggle, controller: :favorite_albums
  end

  private

  def require_login
    unless current_user
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'ログインが必要です' }
        format.json { render json: { status: 'error', message: 'ログインが必要です' }, status: 401 }
      end
    end
  end
end
