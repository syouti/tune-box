class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # メール確認を送信
      @user.send_confirmation_email

      redirect_to login_path, notice: 'アカウントが作成されました！メールアドレスの確認をお願いします。'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @favorite_live_events = @user.favorite_live_events.order(date: :asc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # パスワードが空の場合はパスワード関連のパラメータを除外
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールが正常に更新されました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
