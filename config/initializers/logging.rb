# ログ設定
Rails.logger = ActiveSupport::Logger.new(STDOUT)
Rails.logger.level = Logger::INFO

# リクエストログのカスタマイズ
Rails.application.config.log_tags = [
  :request_id,
  :remote_ip,
  :user_agent
]

# エラーログの詳細化
Rails.application.config.log_level = :info
