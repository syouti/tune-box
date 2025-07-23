class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'アカウントが正常に作成されました！TuneBoxへようこそ！'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @favorite_live_events = @user.favorite_live_events.order(date: :asc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
