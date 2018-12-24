class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  require 'sendgrid-ruby'
  include SendGrid

  mount_uploader :avatar, AvatarUploader

  before_create :set_password
  after_create :set_magic_link
  after_create :send_confirmation_mail

  # virtual attribute to skip password validation while saving
  attr_accessor :skip_password_validation

  def login_procedure
    set_password
    set_magic_link
  end

  protected

  def password_required?
    false
  end

  private

  def set_password
    self.magic_link_token = Devise.friendly_token[0,10]
    self.password = self.magic_link_token
  end

  def set_magic_link
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign magic_link_token

    self.magic_link_key = salt
    self.update(magic_link_token: nil) if self.save
    login_mail(encrypted_data)
  end

  def send_confirmation_mail
    from = Email.new(email: 'no-reply@travelingo.com')
    to = Email.new(email: self.email)
    subject = 'Email confirmation'
    content = Content.new(type: 'text/html', value: 'Change this content and include a magic link for login process.')
    mail = Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: Rails.application.secrets[:sendgrid][:key])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def login_mail(encrypted_data)
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: 'no-reply@travelingo.com')
    mail.subject = 'Login confirmation'
    to = "sumit.yuvasoft131@gmail.com"
    personalization = Personalization.new
    personalization.add_to(Email.new(email: to))
    personalization.subject = 'Login confirmation'
    mail.add_personalization(personalization)
    content = Content.new(type: 'text/html', value: "<html><body>Login with this link <br> <a href='http://localhost:3000/api/v1/users/login_verify?magic_link="+encrypted_data+"&email="+to+"'>Click here</a></body></html>")
    mail.add_content(content)
    sg = SendGrid::API.new(api_key: Rails.application.secrets[:sendgrid][:key])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
    puts response.headers
  end

  def decrypt_magic_link(magic_link)
    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.secret_key_base).generate_key magic_link_key, len

    crypt = ActiveSupport::MessageEncryptor.new key
    password = crypt.decrypt_and_verify(magic_link)
    if self.valid_password?(password)
      # login user
    end
  end
end
