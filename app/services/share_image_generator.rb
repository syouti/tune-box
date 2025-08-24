require 'chunky_png'
require 'open-uri'

class ShareImageGenerator
  def initialize(user, favorite_albums)
    @user = user
    @favorite_albums = favorite_albums
  end

  def generate
    begin
      Rails.logger.info "Starting simple image generation for user #{@user.id}"

      filepath = Rails.root.join('tmp', "share_image_#{@user.id}_#{Time.current.to_i}.png")

      # シンプルな画像を作成（1100x700）
      width = 1100
      height = 700
      main_image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color.rgb(102, 126, 234))

      # 背景を描画
      (0...width).each do |x|
        (0...height).each do |y|
          main_image[x, y] = ChunkyPNG::Color.rgb(102, 126, 234)
        end
      end

      # 中央に白い四角を描画（キャンバス風）
      canvas_x = 50
      canvas_y = 100
      canvas_width = 700
      canvas_height = 500
      
      (canvas_x...canvas_x + canvas_width).each do |x|
        (canvas_y...canvas_y + canvas_height).each do |y|
          main_image[x, y] = ChunkyPNG::Color.rgb(255, 255, 255)
        end
      end

      # 右側に黒い四角を描画（アルバムリスト風）
      list_x = canvas_x + canvas_width + 20
      list_y = canvas_y
      list_width = 280
      list_height = canvas_height
      
      (list_x...list_x + list_width).each do |x|
        (list_y...list_y + list_height).each do |y|
          main_image[x, y] = ChunkyPNG::Color.rgb(0, 0, 0)
        end
      end

      # 画像を保存
      main_image.save(filepath.to_s, :fast_rgba)

      Rails.logger.info "Simple image created successfully"
      Rails.logger.info "Image saved to: #{filepath}"
      filepath

    rescue => e
      Rails.logger.error "Image generation failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
  end
end
