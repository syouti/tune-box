class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # メール確認メールを送信（段階的に有効化）
      begin
        @user.send_confirmation_email
        redirect_to login_path, notice: 'アカウントが作成されました！確認メールを送信しました。メールを確認してログインしてください。'
      rescue => e
        Rails.logger.error "Email sending failed: #{e.message}"
        # メール送信に失敗した場合は直接確認済みにする（フォールバック）
        @user.update(confirmed_at: Time.current) rescue nil
        redirect_to login_path, notice: 'アカウントが作成されました！ログインしてください。'
      end
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
