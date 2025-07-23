class MockLiveDataService
  def self.generate_sample_data
    sample_events = [
      {
        title: "あいみょん CONCERT TOUR 2025",
        artist: "あいみょん",
        venue: "東京ドーム",
        prefecture: "東京都",
        date: 1.month.from_now,
        price: 8500,
        description: "あいみょんの全国ツアー東京公演。最新アルバムからの楽曲を中心とした構成で、ファン待望のライブです。",
        ticket_url: "https://example.com/aimyon-tokyo"
      },
      {
        title: "King Gnu DOME TOUR 2025 \"CEREMONY\"",
        artist: "King Gnu",
        venue: "京セラドーム大阪",
        prefecture: "大阪府",
        date: 2.months.from_now,
        price: 9000,
        description: "King Gnuの大規模ドームツアー。壮大なステージ演出と共に最新楽曲をお届けします。",
        ticket_url: "https://example.com/kinggnu-osaka"
      },
      {
        title: "Official髭男dism LIVE TOUR 2025",
        artist: "Official髭男dism",
        venue: "横浜アリーナ",
        prefecture: "神奈川県",
        date: 6.weeks.from_now,
        price: 7800,
        description: "ヒゲダンの最新ライブツアー横浜公演。話題の新曲も披露予定です。",
        ticket_url: "https://example.com/higedan-yokohama"
      },
      {
        title: "米津玄師 LIVE TOUR 2025",
        artist: "米津玄師",
        venue: "さいたまスーパーアリーナ",
        prefecture: "埼玉県",
        date: 10.weeks.from_now,
        price: 9500,
        description: "米津玄師の全国ツアー埼玉公演。幻想的な演出と共に名曲の数々をお楽しみください。",
        ticket_url: "https://example.com/yonezu-saitama"
      },
      {
        title: "YOASOBI WORLD TOUR 2025 JAPAN",
        artist: "YOASOBI",
        venue: "幕張メッセ",
        prefecture: "千葉県",
        date: 3.months.from_now,
        price: 8000,
        description: "YOASOBIのワールドツアー日本公演。海外でも大人気の楽曲を生でお届けします。",
        ticket_url: "https://example.com/yoasobi-makuhari"
      },
      {
        title: "Vaundy DOME TOUR 2025",
        artist: "Vaundy",
        venue: "ナゴヤドーム",
        prefecture: "愛知県",
        date: 8.weeks.from_now,
        price: 7500,
        description: "Vaundyの初ドームツアー名古屋公演。若手注目アーティストの魅力を存分に味わえます。",
        ticket_url: "https://example.com/vaundy-nagoya"
      },
      {
        title: "BUMP OF CHICKEN TOUR 2025",
        artist: "BUMP OF CHICKEN",
        venue: "福岡 PayPayドーム",
        prefecture: "福岡県",
        date: 4.months.from_now,
        price: 8800,
        description: "バンプオブチキンの九州ツアー。感動的な楽曲と共に特別な夜をお過ごしください。",
        ticket_url: "https://example.com/bump-fukuoka"
      },
      {
        title: "back number LIVE TOUR 2025",
        artist: "back number",
        venue: "真駒内セキスイハイムアイスアリーナ",
        prefecture: "北海道",
        date: 12.weeks.from_now,
        price: 7200,
        description: "back numberの北海道公演。心に響くバラードを中心とした感動のライブです。",
        ticket_url: "https://example.com/backnumber-hokkaido"
      },
      {
        title: "サザンオールスターズ LIVE TOUR 2025",
        artist: "サザンオールスターズ",
        venue: "広島グリーンアリーナ",
        prefecture: "広島県",
        date: 5.months.from_now,
        price: 9800,
        description: "サザンオールスターズの中国地方公演。永遠の名曲たちを生で体感できる貴重な機会です。",
        ticket_url: "https://example.com/southern-hiroshima"
      },
      {
        title: "ONE OK ROCK WORLD TOUR 2025",
        artist: "ONE OK ROCK",
        venue: "仙台サンプラザホール",
        prefecture: "宮城県",
        date: 7.weeks.from_now,
        price: 8300,
        description: "ワンオクの東北ツアー仙台公演。パワフルなロックサウンドを堪能できます。",
        ticket_url: "https://example.com/oneokrock-sendai"
      }
    ]

    sample_events
  end

  def self.seed_database
    puts "🎵 モックライブデータを生成中..."

    # 既存のデータをクリア
    LiveEvent.destroy_all

    generate_sample_data.each do |event_data|
      LiveEvent.create!(event_data)
      puts "✅ #{event_data[:artist]} - #{event_data[:title]} を追加"
    end

    puts "🎉 #{LiveEvent.count} 件のライブデータを生成完了！"
  end

  def self.fetch_live_events(search_params = {})
    # 実際のAPIを模倣したメソッド
    events = LiveEvent.all

    if search_params[:artist].present?
      events = events.where("artist LIKE ?", "%#{search_params[:artist]}%")
    end

    if search_params[:prefecture].present?
      events = events.where(prefecture: search_params[:prefecture])
    end

    if search_params[:date_from].present?
      events = events.where("date >= ?", search_params[:date_from])
    end

    events.order(:date)
  end
end
