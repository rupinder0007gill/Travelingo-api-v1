class Location < ApplicationRecord
  belongs_to :trip

  SEASON = %w(summer winter spring autumn)

end
