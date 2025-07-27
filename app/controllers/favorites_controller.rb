class FavoritesController < ApplicationController
  before_action :require_login
  before_action :set_live_event

  # お気に入りに追加
  def create
    @favorite = current_user.favorites.build(live_event: @live_event)

    if @favorite.save
      respond_to do |format|
        format.html { redirect_to @live_event, notice: 'お気に入りに追加しました' }
        format.json { render json: { status: 'success', favorited: true } }
      end
    else
      respond_to do |format|
        format.html { redirect_to @live_event, alert: 'お気に入りに追加できませんでした' }
        format.json { render json: { status: 'error' } }
      end
    end
  end

  # お気に入りから削除
  def destroy
    @favorite = current_user.favorites.find_by(live_event: @live_event)

    if @favorite&.destroy
      respond_to do |format|
        format.html { redirect_to @live_event, notice: 'お気に入りから削除しました' }
        format.json { render json: { status: 'success', favorited: false } }
      end
    else
      respond_to do |format|
        format.html { redirect_to @live_event, alert: 'お気に入りから削除できませんでした' }
        format.json { render json: { status: 'error' } }
      end
    end
  end

  private

  def set_live_event
    @live_event = LiveEvent.find(params[:id])
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: 'ログインが必要です'
    end
  end
end
