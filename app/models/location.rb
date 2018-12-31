class Location < ApplicationRecord
  belongs_to :trip
  has_many :photos

  SEASON = %w(summer winter spring autumn)

end
