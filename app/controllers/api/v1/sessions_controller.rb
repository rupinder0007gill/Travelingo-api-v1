class Api::V1::SessionsController < DeviseTokenAuth::SessionsController

  def create
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

    @resource = nil
    if field
      q_value = get_case_insensitive_field_from_resource_params(field)
      @resource = find_resource(field, q_value)
    end

    magic_link = params[:session][:magic_link]
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
    data = resource_data(resource_json: @resource.token_validation_response)
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
