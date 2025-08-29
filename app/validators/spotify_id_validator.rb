# Spotify IDのバリデーション
class SpotifyIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    # Spotify IDの形式チェック（22文字の英数字）
    unless value.match?(/\A[a-zA-Z0-9]{22}\z/)
      record.errors.add(attribute, 'は有効なSpotify IDではありません')
    end
  end
end
