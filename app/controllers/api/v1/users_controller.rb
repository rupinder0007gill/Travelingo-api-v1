class Api::V1::UsersController < ApplicationController

  def login
    user = User.find_by(email: params[:email].downcase)
    if user.present?
      user.login_procedure(login_verify_api_v1_users_url)
      @status = 'success'
      @msg = "Confirmation mail sent at #{user.email} with an Magic Link, check your email!"
    else
      @status = 'error'
      @msg = "Email does not exist in out Database!"
    end
    render json: { 
      status: @status,
      msg: @msg
    }
  end

  def login_verify
    user = User.find_by(email: params[:email].downcase)
    magic_link = params[:magic_link]
    @resource = user

    if @resource.present?
      if magic_link.present?
        response = @resource.verify_login_procedure(magic_link)
        if response
          @client_id, @token = @resource.create_token
          @resource.save
          sign_in(:user, @resource, store: false, bypass: false)
          @resource.set_password
          render_create_success
        else
          @msg = "Bad Magic Link"
          render_create_error
        end
      else
        @msg = "Missing Magic Link"
        render_create_error
      end
    else
      @msg = "Missing Email"
      render_create_error
    end
  end

  def render_create_success
    data = @resource.token_validation_response
    data.delete("magic_link")
    data.delete("magic_link_token")
    data.delete("magic_link_key")

    render json: {
      status: "success",
      data: data.merge({client_id: @client_id, token: @token})
    }
  end

  def render_create_error
    render json: {
      status: "error",
      msg: @msg
    }
  end

end
