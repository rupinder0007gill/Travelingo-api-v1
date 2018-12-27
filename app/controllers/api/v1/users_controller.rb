class Api::V1::UsersController < ApplicationController

  def login
    user = User.find_by(email: params[:email].downcase)
    if user.present?
      user.login_procedure(login_verify_api_v1_users_url)
      @msg = "Confirmation mail sent at #{user.email} with an Magic Link, check your email!"
    else
      @msg = "Email does not exist in out Database!"
    end
    render json: {
      status: @status
    }
  end

  def login_verify
    # user = User.find_by(email: params[:email].downcase)
    # magic_link = params[:magic_link]
    # @resource = user

    # if @resource.present?
    #   if magic_link.present?
    #     response = @resource.verify_login_procedure(magic_link)
    #     if response
    #       @client_id, @token, @expiry = @resource.create_token
    #       @resource.save
    #       sign_in(:user, @resource, store: false, bypass: false)
    #       @resource.set_password
    #       render_create_success
    #     else
    #       @msg = "Bad Magic Link"
    #       render_create_error
    #     end
    #   else
    #     @msg = "Missing Magic Link"
    #     render_create_error
    #   end
    # else
    #   @msg = "Missing Email"
    #   render_create_error
    # end
    render json: {
      status: "success",
      data: { magic_link: params[:magic_link], uid: params[:email] }
    }
  end

  # def render_create_success
  #   data = @resource.token_validation_response
  #   data.delete("magic_link")
  #   data.delete("magic_link_token")
  #   data.delete("magic_link_key")

  #   render json: {
  #     status: "success",
  #     data: data.merge({client_id: @client_id, token: @token, expiry: @expiry})
  #   }
  # end

  # def render_create_error
  #   render json: {
  #     status: "error",
  #     msg: @msg
  #   }
  # end

end
