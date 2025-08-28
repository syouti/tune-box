namespace :backup do
  desc "データベースバックアップ"
  task database: :environment do
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    backup_dir = Rails.root.join("backups")
    backup_dir.mkdir unless backup_dir.exist?

    backup_file = backup_dir.join("database_#{timestamp}.sql")

    if Rails.env.production?
      # PostgreSQLの場合
      system("pg_dump $DATABASE_URL > #{backup_file}")
    else
      # SQLiteの場合
      system("sqlite3 #{Rails.root.join('db', 'development.sqlite3')} .dump > #{backup_file}")
    end

    puts "バックアップ完了: #{backup_file}"
  end

  desc "古いバックアップファイルを削除（30日以上前）"
  task cleanup: :environment do
    backup_dir = Rails.root.join("backups")
    return unless backup_dir.exist?

    cutoff_date = 30.days.ago
    backup_dir.glob("*.sql").each do |file|
      if file.mtime < cutoff_date
        file.delete
        puts "削除: #{file}"
      end
    end
  end
end
