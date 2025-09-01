Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.require_master_key = false
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.active_storage.service = :local
  config.force_ssl = false
  config.log_level = :error
  config.log_tags = [ :subdomain, :request_id ]
  config.cache_store = :memory_store
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.active_support.disallowed_deprecation = :log
  config.active_support.disallowed_deprecation_warnings = []
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  # メール設定
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: ENV['SMTP_DOMAIN'] || 'tunebox.jp' }
  
  # SMTP設定
  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_ADDRESS'] || 'smtp.gmail.com',
    port: ENV['SMTP_PORT'] || 587,
    domain: ENV['SMTP_DOMAIN'] || 'tunebox.jp',
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
  }
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = "1.0"
  config.assets.initialize_on_precompile = false
  config.log_to_stdout = true
end
