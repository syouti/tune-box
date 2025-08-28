class SpotifyService
  require 'net/http'
  require 'json'

  def initialize
    @client_id = ENV['SPOTIFY_CLIENT_ID']
    @client_secret = ENV['SPOTIFY_CLIENT_SECRET']
    @access_token = get_access_token
  end

  def get_popular_albums
    # 人気のアルバムIDリスト
    popular_album_ids = [
      '4aawyAB9vmqN3uQ7FjRGTy', # The Weeknd - Starboy
      '1UQp6Lc3UQv4m2MxHRxzyM', # Dua Lipa - Future Nostalgia
      '4iJyoBOLtHqaGxP12qzhQI', # The Weeknd - After Hours
      '6kAsbP8pxwa1642wX8WpqL', # Post Malone - Hollywood's Bleeding
      '2nLOHgzXbeFEoMyu5ZSwiu', # Billie Eilish - WHEN WE ALL FALL ASLEEP
      '3HqSLGZIFdh6gJgHpb9edi', # Taylor Swift - folklore
      '4aawyAB9vmqN3uQ7FjRGTy', # The Weeknd - Starboy
      '1UQp6Lc3UQv4m2MxHRxzyM', # Dua Lipa - Future Nostalgia
      '4iJyoBOLtHqaGxP12qzhQI', # The Weeknd - After Hours
      '6kAsbP8pxwa1642wX8WpqL', # Post Malone - Hollywood's Bleeding
      '2nLOHgzXbeFEoMyu5ZSwiu', # Billie Eilish - WHEN WE ALL FALL ASLEEP
      '3HqSLGZIFdh6gJgHpb9edi'  # Taylor Swift - folklore
    ]

    albums = []
    popular_album_ids.each do |album_id|
      album_data = get_album(album_id)
      if album_data && album_data['images']&.any?
        albums << {
          id: album_id,
          name: album_data['name'],
          artist: album_data['artists']&.first&.dig('name'),
          image_url: album_data['images'].first['url']
        }
      end
    end
    albums
  rescue => e
    Rails.logger.error "Spotify API error: #{e.message}"
    # エラー時はデフォルト画像を返す
    get_default_albums
  end

  private

  def get_access_token
    uri = URI('https://accounts.spotify.com/api/token')
    request = Net::HTTP::Post.new(uri)
    request.basic_auth(@client_id, @client_secret)
    request.set_form_data('grant_type' => 'client_credentials')

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['access_token']
    else
      Rails.logger.error "Failed to get Spotify access token: #{response.body}"
      nil
    end
  end

  def get_album(album_id)
    return nil unless @access_token

    uri = URI("https://api.spotify.com/v1/albums/#{album_id}")
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@access_token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      Rails.logger.error "Failed to get album #{album_id}: #{response.body}"
      nil
    end
  end

  def get_default_albums
    # デフォルトの音楽関連画像
    [
      { id: '1', name: 'Music', image_url: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=120&h=120&fit=crop&crop=center' },
      { id: '2', name: 'Studio', image_url: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=120&h=120&fit=crop&crop=center' },
      { id: '3', name: 'Live', image_url: 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=120&h=120&fit=crop&crop=center' },
      { id: '4', name: 'Recording', image_url: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=120&h=120&fit=crop&crop=center' },
      { id: '5', name: 'Performance', image_url: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=120&h=120&fit=crop&crop=center' },
      { id: '6', name: 'Music', image_url: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=120&h=120&fit=crop&crop=center' },
      { id: '7', name: 'Studio', image_url: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=120&h=120&fit=crop&crop=center' },
      { id: '8', name: 'Live', image_url: 'https://images.unsplash.com/photo-1514320291840-2e0a9bf2a9ae?w=120&h=120&fit=crop&crop=center' },
      { id: '9', name: 'Recording', image_url: 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=120&h=120&fit=crop&crop=center' },
      { id: '10', name: 'Performance', image_url: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=120&h=120&fit=crop&crop=center' },
      { id: '11', name: 'Music', image_url: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=120&h=120&fit=crop&crop=center' },
      { id: '12', name: 'Studio', image_url: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=120&h=120&fit=crop&crop=center' }
    ]
  end
end
