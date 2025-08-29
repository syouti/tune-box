class SessionsController < ApplicationController
  def new
    # ログインフォームを表示
  end

    def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # unless user.confirmed?
      #   flash.now[:alert] = 'メールアドレスの確認が必要です。確認メールを再送信しました。'
      #   user.send_confirmation_email
      #   render :new
      #   return
      # end

      # セッション固定攻撃対策
      reset_session
      session[:user_id] = user.id

      # ログイン情報を記録
      user.update(last_login_at: Time.current, login_count: user.login_count + 1)

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
