# app/controllers/health_controller.rb
class HealthController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def check
    render json: { status: 'ok', timestamp: Time.current }, status: :ok
  end
end
