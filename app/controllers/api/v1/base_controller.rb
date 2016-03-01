class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :destroy_session

  def destroy_session
    request.session_options[:skip] = true
  end

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render template: 'static_pages/record_not_found.html.haml'
  end
end
