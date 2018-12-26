class Api::V1::RegistrationsController < DeviseTokenAuth::RegistrationsController

  def create
    super do |resource|
    end
  end

  def render_create_success
    render json: {
      status: 'success',
      data: { id: resource_data['uid'], first_name: resource_data['first_name'], last_name: resource_data['last_name'] }
    }
  end

end
