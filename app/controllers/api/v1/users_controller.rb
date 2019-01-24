class Api::V1::UsersController < ApplicationController

  def login
    user = User.find_by(email: params[:email].downcase)
    if user.present?
      user.send_login_mail
      @status = 'success'
      @msg = "Confirmation mail sent at #{user.email} with an Magic Link, check your email!"
    else
      @status = 'error'
      @msg = "Email does not exist in out Database."
    end
    render json: {
      status: @status,
      code: @code,
      msg: @msg
    }
  end

  def login_verify
    render json: {
      status: "success",
      data: { magic_link: params[:magic_link], uid: params[:email] }
    }
  end

end
