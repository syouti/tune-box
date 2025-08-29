namespace :setup do
  desc "本番環境のデータベースセットアップ"
  task production: :environment do
    puts "本番環境のデータベースセットアップを開始..."
    
    # 必要なカラムを追加
    unless column_exists?(:users, :confirmed_at)
      add_column :users, :confirmed_at, :datetime
      puts "✓ confirmed_at カラムを追加"
    end
    
    unless column_exists?(:users, :confirmation_token)
      add_column :users, :confirmation_token, :string
      puts "✓ confirmation_token カラムを追加"
    end
    
    unless column_exists?(:users, :confirmation_sent_at)
      add_column :users, :confirmation_sent_at, :datetime
      puts "✓ confirmation_sent_at カラムを追加"
    end
    
    unless column_exists?(:users, :last_login_at)
      add_column :users, :last_login_at, :datetime
      puts "✓ last_login_at カラムを追加"
    end
    
    unless column_exists?(:users, :login_count)
      add_column :users, :login_count, :integer, default: 0
      puts "✓ login_count カラムを追加"
    end
    
    puts "本番環境のデータベースセットアップが完了しました！"
  end
end
