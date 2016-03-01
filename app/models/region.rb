class Region < ActiveRecord::Base
  has_many :station, foreign_key: :region_id
  validates :id, uniqueness: true
  self.primary_key = :id

  def stations
    self.station.count
  end

  def longitude
    self.station.all.average(:longitude).to_i || self.station.first.longitude.to_i
  end

  def latitude
    self.station.all.average(:latitude).to_i || self.station.first.latitude.to_i
  end
end
