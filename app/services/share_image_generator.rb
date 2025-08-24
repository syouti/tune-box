require 'mini_magick'
require 'open-uri'

class ShareImageGenerator
  def initialize(user, favorite_albums)
    @user = user
    @favorite_albums = favorite_albums
    @canvas_width = 700
    @canvas_height = 700
    @list_width = 400
    @total_width = @canvas_width + @list_width
    @total_height = @canvas_height
  end

    def generate
    begin
      Rails.logger.info "Starting image generation for user #{@user.id}"
      
      # シンプルな画像を作成（テスト用）
      main_image = MiniMagick::Image.new("800x600")
      main_image.format "png"
      
      Rails.logger.info "Created test image: 800x600"

      # シンプルな背景を作成
      main_image.combine_options do |c|
        c.fill "#667eea"
        c.draw "rectangle 0,0 800,600"
      end
      Rails.logger.info "Background created"

      # シンプルなテキストを追加
      main_image.combine_options do |c|
        c.fill "white"
        c.font "Arial"
        c.pointsize "24"
        c.draw "text 50,100 'TuneBox Share Image'"
        c.draw "text 50,150 'User: #{@user.name}'"
        c.draw "text 50,200 'Albums: #{@favorite_albums.count}'"
      end
      Rails.logger.info "Text added"

      # 画像を保存
      filename = "share_image_#{@user.id}_#{Time.current.to_i}.png"
      filepath = Rails.root.join('tmp', filename)
      main_image.write(filepath)
      
      Rails.logger.info "Image saved to: #{filepath}"
      filepath
      
    rescue => e
      Rails.logger.error "Image generation failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
  end

  private

  def create_background(image)
    # シンプルな背景を作成（グラデーションの代わり）
    image.combine_options do |c|
      c.fill "#667eea"
      c.draw "rectangle 0,0 #{@total_width},#{@total_height}"
    end
  end

  def draw_canvas_section(image)
    # キャンバス背景（黒いグリッド）
    canvas_bg = MiniMagick::Image.new("#{@canvas_width}x#{@canvas_height}")
    canvas_bg.format "png"

    # 黒い背景を作成
    canvas_bg.combine_options do |c|
      c.fill "black"
      c.draw "rectangle 0,0 #{@canvas_width},#{@canvas_height}"
    end

    # グリッド線を描画
    draw_grid_lines(canvas_bg)

    # アルバムジャケットを配置
    draw_album_jackets(canvas_bg)

    # メイン画像に合成
    image.composite(canvas_bg) do |c|
      c.geometry "+0+80" # ヘッダー分をオフセット
    end
  end

  def draw_grid_lines(canvas_bg)
    # グリッド線を描画
    canvas_bg.combine_options do |c|
      c.stroke "rgba(255,255,255,0.2)"
      c.strokewidth "1"

      # 縦線
      (1..4).each do |i|
        x = i * 140
        c.draw "line #{x},0 #{x},#{@canvas_height}"
      end

      # 横線
      (1..4).each do |i|
        y = i * 140
        c.draw "line 0,#{y} #{@canvas_width},#{y}"
      end
    end
  end

  def draw_album_jackets(canvas_bg)
    @favorite_albums.each_with_index do |album, index|
      # アルバムの位置を計算
      if album.position_x.present? && album.position_y.present?
        x = album.position_x
        y = album.position_y
      else
        grid_x = index % 5
        grid_y = (index / 5).floor
        x = grid_x * 140
        y = grid_y * 140
      end

      # アルバムジャケット画像をダウンロードして配置
      begin
        album_image = download_album_image(album.image_url)
        if album_image
          # 140x140にリサイズ
          album_image.resize "140x140"

          # キャンバスに配置
          canvas_bg.composite(album_image) do |c|
            c.geometry "+#{x}+#{y}"
          end
        end
      rescue => e
        Rails.logger.error "Failed to download album image: #{e.message}"
      end
    end
  end

  def draw_album_list_section(image)
    # アルバムリスト背景
    list_bg = MiniMagick::Image.new("#{@list_width}x#{@canvas_height}")
    list_bg.format "png"

    # 黒い背景を作成
    list_bg.combine_options do |c|
      c.fill "#000000"
      c.draw "rectangle 0,0 #{@list_width},#{@canvas_height}"
    end

    # アルバムリストの内容を描画
    draw_album_list_content(list_bg)

    # メイン画像に合成
    image.composite(list_bg) do |c|
      c.geometry "+#{@canvas_width}+80" # キャンバスの右側、ヘッダー分をオフセット
    end
  end

  def draw_album_list_content(list_bg)
    # ヘッダー
    list_bg.combine_options do |c|
      c.fill "white"
      c.font "Arial-Bold"
      c.pointsize "24"
      c.draw "text 20,40 'アルバムリスト'"
    end

    # アルバムリスト
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
      y_position = 80 + (index * 25)

      # 番号
      list_bg.combine_options do |c|
        c.fill "#667eea"
        c.font "Arial-Bold"
        c.pointsize "14"
        c.draw "text 20,#{y_position} '#{index + 1}'"
      end

      # アルバム名
      list_bg.combine_options do |c|
        c.fill "white"
        c.font "Arial"
        c.pointsize "12"
        # 長いタイトルは省略
        title = album.name.length > 20 ? album.name[0..19] + "..." : album.name
        c.draw "text 50,#{y_position} '#{title}'"
      end

      # アーティスト名
      list_bg.combine_options do |c|
        c.fill "#cccccc"
        c.font "Arial"
        c.pointsize "10"
        # 長いアーティスト名は省略
        artist = album.artist.length > 15 ? album.artist[0..14] + "..." : album.artist
        c.draw "text 50,#{y_position + 15} '#{artist}'"
      end
    end
  end

  def draw_header(image)
    # ヘッダー背景
    header_bg = MiniMagick::Image.new("#{@total_width}x80")
    header_bg.format "png"

    # 半透明の白い背景
    header_bg.combine_options do |c|
      c.fill "rgba(255,255,255,0.95)"
      c.draw "rectangle 0,0 #{@total_width},80"
    end

    # タイトル
    header_bg.combine_options do |c|
      c.fill "#667eea"
      c.font "Arial-Bold"
      c.pointsize "32"
      c.draw "text 20,50 'TuneBox'"
    end

    # ユーザー名
    header_bg.combine_options do |c|
      c.fill "#333333"
      c.font "Arial"
      c.pointsize "18"
      c.draw "text 20,75 '#{@user.name}の名盤リスト'"
    end

    # メイン画像に合成
    image.composite(header_bg) do |c|
      c.geometry "+0+0"
    end
  end

  def draw_footer(image)
    # フッター背景を直接描画
    image.combine_options do |c|
      c.fill "#2c3e50"
      c.draw "rectangle 0,#{@total_height - 60} #{@total_width},#{@total_height}"

      # フッターテキスト
      c.fill "white"
      c.font "Arial"
      c.pointsize "14"
      c.draw "text 20,#{@total_height - 25} 'Generated by TuneBox'"
      c.draw "text 20,#{@total_height - 10} '#{Time.current.strftime('%Y年%m月%d日')}'"
    end
  end

  def download_album_image(image_url)
    return nil if image_url.blank?

    begin
      # 画像をダウンロード
      downloaded_image = URI.open(image_url)
      temp_file = Tempfile.new(['album_image', '.jpg'])
      temp_file.binmode
      temp_file.write(downloaded_image.read)
      temp_file.close

      # MiniMagickで画像を読み込み
      MiniMagick::Image.open(temp_file.path)
    rescue => e
      Rails.logger.error "Failed to download image from #{image_url}: #{e.message}"
      nil
    ensure
      temp_file&.unlink
    end
  end
end
