class Api::V1::UsersController < ApplicationController

  def login
    user = User.find_by(email: params[:email])
    if user.present?
      user.login_procedure
      @msg = "Confirmation mail sent with an Magic Link, check your email!"
    else
      @msg = "Email does not exist in out Database!"
    end
    # json formate response
  end

  def login_verify
    user = User.find_by(email: params[:email])
    if user.present?
      user.decrypt_magic_link(params[:magic_link])
    else
      "Invalid email id!"
    end

    redirect_to '/'
  end

end
