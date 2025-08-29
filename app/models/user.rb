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
