class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  require 'sendgrid-ruby'
  include SendGrid

  mount_uploader :avatar, AvatarUploader

  has_many :trips

  after_create :send_confirmation_mail

  # virtual attribute to skip password validation while saving
  attr_accessor :skip_password_validation

  def decrypt_magic_link(magic_link)
    magic_link = magic_link.gsub(' ', '+')
    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key magic_link_key, len
    crypt = ActiveSupport::MessageEncryptor.new key
    password = crypt.decrypt_and_verify(magic_link) rescue ""
    return self.valid_password?(password)
  end

  def send_confirmation_mail
    set_password
    set_magic_link('signup')
  end

  def send_login_mail
    set_password
    set_magic_link('login')
  end

  def verify_login_procedure(magic_link)
    decrypt_magic_link(magic_link)
  end

  def set_password
    self.magic_link_token = Devise.friendly_token[0,10]
    self.password = self.magic_link_token
  end

  def set_magic_link(type=nil)
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign magic_link_token

    self.magic_link_key = salt
    if self.save
      self.update(magic_link_token: nil)
    end
    api_url = "http://localhost:3000/api/v1/users/login_verify"

    api_call = api_url + "?magic_link=#{encrypted_data}&email=#{self.email}"

    send_mail_via_sendgrid(api_call, type)
  end

  private
    def new_sendgrid_request
      SendGrid::API.new(api_key: Rails.application.secrets[:sendgrid][:key])
    end

    def send_mail_via_sendgrid(api_call, type)
      to = self.email
      mail = SendGrid::Mail.new
      mail.from = Email.new(email: 'no-reply@travelingo.com')
      mail.subject = 'Login confirmation'
      personalization = Personalization.new
      personalization.add_to(Email.new(email: to))
      personalization.subject = type.eql?('login') ? 'Login confirmation' : 'Email Confirmation'
      mail.add_personalization(personalization)

      value = if type.eql?('login')
                "<html><body>Login with this link <br> <a method='post' href='" + api_call + "'>Click here</a></body></html>"
              else
                "<html><body>Confirm your account and login with this link <br> <a method='post' href='" + api_call + "'>Click here</a></body></html>"
              end

      content = Content.new(type: 'text/html', value: value)

      mail.add_content(content)
      response = new_sendgrid_request.client.mail._('send').post(request_body: mail.to_json)
    end

  protected

    def password_required?
      false
    end

end

