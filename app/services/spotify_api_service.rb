class SpotifyApiService
  include HTTParty
  base_uri 'https://api.spotify.com/v1'

  def initialize
    @access_token = get_access_token
    puts "🔐 Access Token: #{@access_token.present? ? 'OK' : 'NG'}"
  end

  def search_albums(query, limit: 20, offset: 0)
    return { albums: [], total: 0 } if query.blank?

    puts "🔍 Searching for: #{query} (offset: #{offset}, limit: #{limit})"
    puts "🔑 Using token: #{@access_token.present? ? 'Yes' : 'No'}"

    options = {
      headers: {
        'Authorization' => "Bearer #{@access_token}",
        'Content-Type' => 'application/json'
      },
      query: {
        q: query,
        type: 'album',
        limit: limit,
        offset: offset
      }
    }

    response = self.class.get('/search', options)

    puts "📡 API Response Status: #{response.code}"

    if response.success?
      albums_data = response['albums']
      albums = parse_albums(albums_data['items'])
      total = albums_data['total']

      puts "✅ Found #{albums.count} albums (Total: #{total})"

      {
        albums: albums,
        total: total,
        offset: offset,
        limit: limit
      }
    else
      puts "❌ Spotify API Error: #{response.body}"
      Rails.logger.error "Spotify API Error: #{response.body}"
      { albums: [], total: 0 }
    end
  end

  private

  def get_access_token
    client_id = ENV['SPOTIFY_CLIENT_ID']
    client_secret = ENV['SPOTIFY_CLIENT_SECRET']

    puts "🔑 Client ID: #{client_id.present? ? 'OK' : 'NG'}"
    puts "🔐 Client Secret: #{client_secret.present? ? 'OK' : 'NG'}"

    auth_string = Base64.strict_encode64("#{client_id}:#{client_secret}")

    options = {
      headers: {
        'Authorization' => "Basic #{auth_string}",
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      body: 'grant_type=client_credentials'
    }

    response = HTTParty.post('https://accounts.spotify.com/api/token', options)

    puts "🔗 Auth Response Status: #{response.code}"

    if response.success?
      puts "✅ Authentication successful"
      response['access_token']
    else
      puts "❌ Spotify Auth Error: #{response.body}"
      Rails.logger.error "Spotify Auth Error: #{response.body}"
      nil
    end
  end

  def parse_albums(albums_data)
    albums_data.map do |album|
      {
        spotify_id: album['id'],
        name: album['name'],
        artist: album['artists'].map { |artist| artist['name'] }.join(', '),
        release_date: album['release_date'],
        image_url: album['images'].first&.dig('url'),
        external_url: album['external_urls']['spotify'],
        total_tracks: album['total_tracks']
      }
    end
  end
end
