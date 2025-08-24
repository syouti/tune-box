require 'chunky_png'
require 'open-uri'

class ShareImageGenerator
  def initialize(user, favorite_albums)
    @user = user
    @favorite_albums = favorite_albums
  end

  def generate
    begin
      Rails.logger.info "Starting enhanced image generation for user #{@user.id}"

      filepath = Rails.root.join('tmp', "share_image_#{@user.id}_#{Time.current.to_i}.png")

      # メイン画像を作成（1100x700）
      width = 1100
      height = 700
      main_image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color.rgb(102, 126, 234))

      # 背景を描画
      (0...width).each do |x|
        (0...height).each do |y|
          main_image[x, y] = ChunkyPNG::Color.rgb(102, 126, 234)
        end
      end

      # ヘッダー部分を描画
      draw_header(main_image)

      # キャンバス部分を描画（左側）
      draw_canvas(main_image)

      # アルバムリスト部分を描画（右側）
      draw_album_list(main_image)

      # 画像を保存
      main_image.save(filepath.to_s, :fast_rgba)

      Rails.logger.info "Enhanced image created successfully"
      Rails.logger.info "Image saved to: #{filepath}"
      filepath

    rescue => e
      Rails.logger.error "Image generation failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
  end

  private

  def draw_header(image)
    # ヘッダー背景（半透明の白）
    header_y = 0
    header_height = 80

    (0...1100).each do |x|
      (header_y...header_y + header_height).each do |y|
        image[x, y] = ChunkyPNG::Color.rgba(255, 255, 255, 230)
      end
    end

    # タイトル部分（青色のブロック）
    title_x = 20
    title_y = 20
    title_width = 200
    title_height = 40

    (title_x...title_x + title_width).each do |x|
      (title_y...title_y + title_height).each do |y|
        image[x, y] = ChunkyPNG::Color.rgb(102, 126, 234)
      end
    end
  end

  def draw_canvas(image)
    # キャンバス背景（黒いグリッド）
    canvas_x = 50
    canvas_y = 100
    canvas_width = 700
    canvas_height = 500

    # 黒い背景
    (canvas_x...canvas_x + canvas_width).each do |x|
      (canvas_y...canvas_y + canvas_height).each do |y|
        image[x, y] = ChunkyPNG::Color.rgb(0, 0, 0)
      end
    end

    # グリッド線（白い線）
    grid_size = 140
    (1..4).each do |i|
      x = canvas_x + i * grid_size
      (canvas_y...canvas_y + canvas_height).each do |y|
        image[x, y] = ChunkyPNG::Color.rgba(255, 255, 255, 50)
      end
    end

    (1..4).each do |i|
      y = canvas_y + i * grid_size
      (canvas_x...canvas_x + canvas_width).each do |x|
        image[x, y] = ChunkyPNG::Color.rgba(255, 255, 255, 50)
      end
    end

        # アルバムジャケットを配置
    @favorite_albums.each_with_index do |album, index|
      if index < 25 # 最大25個まで
        # 位置を計算
        if album.position_x.present? && album.position_y.present?
          grid_x = (album.position_x / 140).to_i
          grid_y = (album.position_y / 140).to_i
        else
          grid_x = index % 5
          grid_y = (index / 5).floor
        end

        # 座標の範囲チェック
        if grid_x >= 0 && grid_x < 5 && grid_y >= 0 && grid_y < 5
          album_x = canvas_x + grid_x * grid_size + 10
          album_y = canvas_y + grid_y * grid_size + 10
          album_size = 120

          # 画像の範囲内かチェック
          if album_x + album_size <= canvas_x + canvas_width && 
             album_y + album_size <= canvas_y + canvas_height

            # アルバムジャケット（グレーのブロック + 番号）
            (album_x...album_x + album_size).each do |x|
              (album_y...album_y + album_size).each do |y|
                image[x, y] = ChunkyPNG::Color.rgb(100, 100, 100)
              end
            end

            # 番号を描画（小さな白い四角）
            number_x = album_x + 5
            number_y = album_y + 5
            number_size = 20
            
            (number_x...number_x + number_size).each do |x|
              (number_y...number_y + number_size).each do |y|
                image[x, y] = ChunkyPNG::Color.rgb(255, 255, 255)
              end
            end
          end
        end
      end
    end
  end

  def draw_album_list(image)
    # アルバムリスト背景（黒）
    list_x = 800
    list_y = 100
    list_width = 280
    list_height = 500

    (list_x...list_x + list_width).each do |x|
      (list_y...list_y + list_height).each do |y|
        image[x, y] = ChunkyPNG::Color.rgb(0, 0, 0)
      end
    end

    # アルバムリストの内容
    sorted_albums = @favorite_albums.sort_by do |album|
      if album.position_x.present? && album.position_y.present?
        grid_y = (album.position_y / 140).to_i
        grid_x = (album.position_x / 140).to_i
      else
        index = @favorite_albums.index(album)
        grid_y = (index / 5).floor
        grid_x = index % 5
      end
      [grid_y, grid_x]
    end

    sorted_albums.each_with_index do |album, index|
      if index < 25
        item_y = list_y + 20 + index * 20

        # 番号（青色の小さなブロック）
        number_x = list_x + 10
        number_size = 15
        (number_x...number_x + number_size).each do |x|
          (item_y...item_y + number_size).each do |y|
            image[x, y] = ChunkyPNG::Color.rgb(102, 126, 234)
          end
        end

        # アルバム名（白いブロック）
        title_x = list_x + 35
        title_y = item_y
        title_width = 120
        title_height = 10
        (title_x...title_x + title_width).each do |x|
          (title_y...title_y + title_height).each do |y|
            image[x, y] = ChunkyPNG::Color.rgb(255, 255, 255)
          end
        end

        # アーティスト名（グレーのブロック）
        artist_x = list_x + 35
        artist_y = item_y + 12
        artist_width = 100
        artist_height = 8
        (artist_x...artist_x + artist_width).each do |x|
          (artist_y...artist_y + artist_height).each do |y|
            image[x, y] = ChunkyPNG::Color.rgb(150, 150, 150)
          end
        end
      end
    end
  end
end
