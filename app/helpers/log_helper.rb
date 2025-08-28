# ログヘルパー
module LogHelper
  # ユーザーアクションのログ
  def log_user_action(action, details = {})
    Rails.logger.info(
      "USER_ACTION: #{action} | " \
      "User: #{current_user&.id || 'guest'} | " \
      "IP: #{request.remote_ip} | " \
      "Details: #{details}"
    )
  end

  # エラーのログ
  def log_error(error, context = {})
    Rails.logger.error(
      "ERROR: #{error.class} | " \
      "Message: #{error.message} | " \
      "User: #{current_user&.id || 'guest'} | " \
      "IP: #{request.remote_ip} | " \
      "Context: #{context}"
    )
  end

  # パフォーマンスのログ
  def log_performance(operation, duration, details = {})
    Rails.logger.info(
      "PERFORMANCE: #{operation} | " \
      "Duration: #{duration}ms | " \
      "User: #{current_user&.id || 'guest'} | " \
      "Details: #{details}"
    )
  end
end
