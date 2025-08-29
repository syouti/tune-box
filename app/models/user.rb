class User < ApplicationRecord
  has_secure_password

  # アソシエーションを追加
  has_many :favorite_albums, dependent: :destroy
  has_many :albums, through: :favorite_albums

  # バリデーション強化
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'は有効なメールアドレスではありません' }
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :password, length: { minimum: 8 }, if: :password_required?

  # セキュリティ: データのサニタイズ
  before_save :sanitize_data

  # メール確認機能
  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_email
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_sent_at = Time.current
    save!
    UserMailer.confirmation_email(self).deliver_now
  end

  def confirm_email!
    self.confirmed_at = Time.current
    self.confirmation_token = nil
    save!
  end

  def confirmation_expired?
    confirmation_sent_at.present? && confirmation_sent_at < 24.hours.ago
  end

  # メール確認前はアカウントを無効化
  def active_for_authentication?
    super && confirmed?
  end

  def inactive_message
    confirmed? ? super : :unconfirmed
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def sanitize_data
    self.name = sanitize_string(name) if name.present?
    self.email = email.downcase.strip if email.present?
  end

  def sanitize_string(str)
    # HTMLタグとスクリプトを除去
    ActionController::Base.helpers.sanitize(str, tags: [])
  end
end
