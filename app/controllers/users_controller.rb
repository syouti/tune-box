class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to favorite_albums_path, notice: 'アカウントが正常に作成されました！TuneBoxへようこそ。キャンバスページに移動しました。'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])

    # アクセス制御：自分のプロフィールのみアクセス可能
    unless @user == current_user
      redirect_to root_path, alert: 'アクセス権限がありません'
      return
    end

    # 存在しないアソシエーションの参照を削除（エラー回避）
    # @favorite_live_events = @user.favorite_live_events.order(date: :asc)
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
