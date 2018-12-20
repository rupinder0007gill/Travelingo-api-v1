class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :avatar, AvatarUploader

  before_create :set_password
  after_create :set_magic_link
  # after_create :send_confirmation_mail

  attr_accessor :skip_password_validation # virtual attribute to skip password validation while saving

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
    self.magic_link_key = SecureRandom.random_bytes(32)
    crypt = ActiveSupport::MessageEncryptor.new(magic_link_key)
    encrypted_data = crypt.encrypt_and_sign(magic_link_token)
    self.magic_link = encrypted_data
    self.update(magic_link_token: nil) if self.save
  end

  def decrypt_magic_link
    crypt = ActiveSupport::MessageEncryptor.new(magic_link_key)
    password = crypt.decrypt_and_verify(magic_link)
    if self.valid_password?(password)
      # login user
    end
  end
end
