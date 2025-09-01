class SessionsController < ApplicationController
  def new
    # ログインフォームを表示
  end

    def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # メール認証チェック（段階的に有効化）
      unless user.confirmed?
        flash.now[:alert] = 'メールアドレスの確認が必要です。確認メールを再送信しました。'
        begin
          # 本番環境でのメール設定確認ログ
          if Rails.env.production?
            Rails.logger.info "Production mailer config: #{Rails.application.config.action_mailer.smtp_settings}"
            Rails.logger.info "SMTP environment variables: ADDRESS=#{ENV['SMTP_ADDRESS']}, USERNAME=#{ENV['SMTP_USERNAME']}, DOMAIN=#{ENV['SMTP_DOMAIN']}"
          end
          
          user.send_confirmation_email
        rescue => e
          Rails.logger.error "Confirmation email resend failed: #{e.message}"
          Rails.logger.error "Backtrace: #{e.backtrace.join("\n")}"
        end
        render :new
        return
      end

      # セッション固定攻撃対策
      reset_session
      session[:user_id] = user.id

      # ログイン情報を記録（一時的に無効化）
      # user.update(last_login_at: Time.current, login_count: user.login_count + 1)

      redirect_to favorite_albums_path, notice: "#{user.name}さん、おかえりなさい！キャンバスページに移動しました。"
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが正しくありません。'
      render :new
    end
    end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  def clear_session
    session[:user_id] = nil
    redirect_to root_path, notice: 'セッションをクリアしました。'
  end
end
