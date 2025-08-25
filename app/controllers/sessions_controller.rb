class SessionsController < ApplicationController
  def new
    # ログインフォームを表示
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # セッション固定攻撃対策：ログイン成功時にセッションをリセット
      reset_session
      session[:user_id] = user.id

      # セキュリティログ（機能に影響なし）
      Rails.logger.info "User #{user.id} logged in from IP: #{request.remote_ip}"

      redirect_to favorite_albums_path, notice: "#{user.name}さん、おかえりなさい！キャンバスページに移動しました。"
    else
      # セキュリティログ（機能に影響なし）
      Rails.logger.warn "Failed login attempt for email: #{params[:session][:email]} from IP: #{request.remote_ip}"

      flash.now[:alert] = 'メールアドレスまたはパスワードが正しくありません。'
      render :new
    end
  end

  def destroy
    if current_user
      Rails.logger.info "User #{current_user.id} logged out from IP: #{request.remote_ip}"
    end

    session[:user_id] = nil
    redirect_to root_path, notice: 'ログアウトしました。'
  end
end
