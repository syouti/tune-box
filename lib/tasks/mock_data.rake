namespace :mock do
  desc "Generate mock live event data"
  task seed: :environment do
    MockLiveDataService.seed_database
  end

  desc "Clear all live event data"
  task clear: :environment do
    puts "🗑️  既存のライブデータを削除中..."
    LiveEvent.destroy_all
    puts "✅ 削除完了！"
  end

  desc "Reset and generate fresh mock data"
  task reset: :environment do
    Rake::Task['mock:clear'].invoke
    Rake::Task['mock:seed'].invoke
  end
end
