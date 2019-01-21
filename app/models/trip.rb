class Trip < ApplicationRecord
  belongs_to :user
  has_one :location

  POLICIES = %w(active_with_policy active_without_policy inactive_with_policy inactive_without_policy)
end
