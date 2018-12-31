class AddColumnVerifiedIntoUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :email_verified, :boolean, default: false
    add_column :users, :avatarURL, :string
  end
end
