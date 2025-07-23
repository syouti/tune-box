class LiveEventsController < ApplicationController
  def index
    @live_events = LiveEvent.all.order(date: :asc)

    # 検索機能
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @live_events = @live_events.where(
        "title LIKE ? OR artist LIKE ? OR venue LIKE ?",
        search_term, search_term, search_term
      )
    end

    # 都道府県での絞り込み
    if params[:prefecture].present?
      @live_events = @live_events.where(prefecture: params[:prefecture])
    end

    # 日付での絞り込み
    if params[:date_from].present?
      @live_events = @live_events.where("date >= ?", params[:date_from])
    end

    if params[:date_to].present?
      @live_events = @live_events.where("date <= ?", params[:date_to])
    end
  end

  def show
    @live_event = LiveEvent.find(params[:id])
  end

  def new
    @live_event = LiveEvent.new
  end

  def create
    @live_event = LiveEvent.new(live_event_params)

    if @live_event.save
      redirect_to @live_event, notice: 'ライブイベントが正常に作成されました。'
    else
      render :new
    end
  end

  private

  def live_event_params
    params.require(:live_event).permit(:title, :artist, :venue, :date, :description, :ticket_url, :price, :prefecture)
  end
end
