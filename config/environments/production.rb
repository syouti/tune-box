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
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = false
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = "1.0"
  config.assets.initialize_on_precompile = false
  config.log_to_stdout = true
end
