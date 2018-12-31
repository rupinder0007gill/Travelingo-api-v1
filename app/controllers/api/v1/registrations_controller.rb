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


Considerations for Users:

Email Verified can have: “true” or “False”

Roles can have: “primary_traveler” or “traveler”

Trips is reference from Trips API and can have: “active_with_policy”, “active_without_policy”, “inactive_with_policy”,
“inactive_without_policy”

Location_season can have: “summer, “winter”, “spring”, “autumn” - we this from both the start date and the end
date. I presume if a user has a date like: 30 Oct 18 - 2 Dec 18 and goes to Sweden, then the table will have both
“Spring” and “Summer”