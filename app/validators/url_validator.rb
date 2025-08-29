# URLのバリデーション
class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    # URLの形式チェック
    uri = URI.parse(value)
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      record.errors.add(attribute, 'は有効なURLではありません')
    end
  rescue URI::InvalidURIError
    record.errors.add(attribute, 'は有効なURLではありません')
  end
end
