class SessionsController < ApplicationController
  def new
    # ログインフォームを表示
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
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
end
