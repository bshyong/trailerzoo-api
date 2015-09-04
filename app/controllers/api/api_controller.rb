class Api::ApiController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def current_user
    @current_user ||= User.where.not(auth_token: nil).find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless current_user.present?
  end

  def user_signed_in?
    current_user.present?
  end
end
