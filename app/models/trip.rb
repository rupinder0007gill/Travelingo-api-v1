class Trip < ApplicationRecord
  belongs_to :user

  POLICIES = %w(active_with_policy active_without_policy inactive_with_policy inactive_without_policy)
  SEASON = %w(summer winter spring autumn)

end
