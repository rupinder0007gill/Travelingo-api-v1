class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def create
    super do |resource|
    end
  end

  def render_create_success
    render json: {
      status: 'success',
      data: { id: resource_data['uid'], first_name: resource_data['first_name'], last_name: resource_data['last_name'] },
      msg: "You have sign up successfully, Confirmation mail sent at EMAIL_ID with an Magic Link, please check your email!."
    }
  end

  def update
    super
  end
end
