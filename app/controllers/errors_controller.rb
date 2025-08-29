class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def not_found
    # log_error(ActionController::RoutingError.new("No route matches [GET] \"#{request.path}\""), {
    #   path: request.path,
    #   method: request.method,
    #   user_agent: request.user_agent
    # })

    respond_to do |format|
      format.html { render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false }
      format.json { render json: { error: 'Not Found', path: request.path }, status: :not_found }
    end
  end

  def internal_server_error
    # log_error(StandardError.new('Internal Server Error'), {
    #   path: request.path,
    #   method: request.method,
    #   user_agent: request.user_agent
    # })

    respond_to do |format|
      format.html { render file: Rails.root.join('public', '500.html'), status: :internal_server_error, layout: false }
      format.json { render json: { error: 'Internal Server Error' }, status: :internal_server_error }
    end
  end

  def unprocessable_entity
    # log_error(ActionController::ParameterMissing.new('Parameter missing'), {
    #   path: request.path,
    #   method: request.method,
    #   params: request.filtered_parameters
    # })

    respond_to do |format|
      format.html { render file: Rails.root.join('public', '422.html'), status: :unprocessable_entity, layout: false }
      format.json { render json: { error: 'Unprocessable Entity' }, status: :unprocessable_entity }
    end
  end
end
