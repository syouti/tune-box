namespace :backup do
  desc "データベースバックアップ"
  task database: :environment do
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    backup_dir = Rails.root.join("backups")
    backup_dir.mkdir unless backup_dir.exist?

    backup_file = backup_dir.join("database_#{timestamp}.sql")

    if Rails.env.production?
      # PostgreSQLの場合
      database_url = ENV['DATABASE_URL']
      if database_url
        system("pg_dump #{database_url} > #{backup_file}")
        puts "✅ 本番環境バックアップ完了: #{backup_file}"
      else
        puts "❌ DATABASE_URLが設定されていません"
      end
    else
      # SQLiteの場合
      db_file = Rails.root.join('db', 'development.sqlite3')
      if File.exist?(db_file)
        system("sqlite3 #{db_file} .dump > #{backup_file}")
        puts "✅ 開発環境バックアップ完了: #{backup_file}"
      else
        puts "❌ データベースファイルが見つかりません: #{db_file}"
      end
    end
  end

  desc "古いバックアップファイルを削除（30日以上前）"
  task cleanup: :environment do
    backup_dir = Rails.root.join("backups")
    return unless backup_dir.exist?

    cutoff_date = 30.days.ago
    deleted_count = 0

    backup_dir.glob("*.sql").each do |file|
      if file.mtime < cutoff_date
        file.delete
        deleted_count += 1
        puts "🗑️ 削除: #{file}"
      end
    end

    puts "✅ 古いバックアップファイル #{deleted_count}個を削除しました"
  end

  desc "バックアップの整合性チェック"
  task verify: :environment do
    backup_dir = Rails.root.join("backups")
    return unless backup_dir.exist?

    latest_backup = backup_dir.glob("*.sql").max_by(&:mtime)
    if latest_backup
      puts "📋 最新バックアップ: #{latest_backup}"
      puts "📅 作成日時: #{latest_backup.mtime}"
      puts "📏 ファイルサイズ: #{latest_backup.size} bytes"

      # ファイルの内容チェック
      content = File.read(latest_backup)
      if content.include?("CREATE TABLE")
        puts "✅ バックアップファイルの整合性: OK"
      else
        puts "❌ バックアップファイルの整合性: NG"
      end
    else
      puts "❌ バックアップファイルが見つかりません"
    end
  end
end
