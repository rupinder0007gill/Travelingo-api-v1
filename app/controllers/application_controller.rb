class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token  
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :dob, :mobile_phone, :avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:uid, :magic_link])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :mobile_phone, :email, :dob, :avatar])
  end
end
