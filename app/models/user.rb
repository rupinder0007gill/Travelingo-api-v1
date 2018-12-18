class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :avatar, AvatarUploader

  before_create :set_password
  after_create :set_magic_link

  attr_accessor :skip_password_validation # virtual attribute to skip password validation while saving

  protected

  def password_required?
    false
  end

  private

  def set_password
    self.password = Devise.friendly_token[0,10]
  end

  def set_magic_link
    link = BCrypt::Password.create(password)
    self.update(magic_link: link)
  end
end
