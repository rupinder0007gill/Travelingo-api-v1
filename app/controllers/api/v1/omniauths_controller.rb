class Api::V1::OmniauthsController < ApplicationController

  def facebook_login
    @graph = Koala::Facebook::API.new(params[:authenticationToken])
    profile = @graph.get_object('me', fields:'hometown,name,email,first_name,last_name')
    @user = User.where(email: profile['email']).first_or_initialize
    if @user.persisted?
      @user.uid = profile['id']
      @msg = "login successfully"
    else
      @user.uid = profile['id']
      @user.first_name = profile['first_name']
      @user.last_name = profile['last_name']
      @user.dob = profile['birthday']
      @msg = "You have sign up successfully."
    end
    @user.save
    @status = 'success'
    @client_token, @token = @user.create_token

    render json: {
      status: @status,
      msg: @msg,
      data: {client_token: @client_token, access_token: @token}
    }
  end

end
