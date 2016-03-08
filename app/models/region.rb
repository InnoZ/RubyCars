class Region < ActiveRecord::Base
  has_many :station, foreign_key: :region_id
  validates :id, uniqueness: true
  self.primary_key = :id

  def stations
    station.count
  end

  def longitude
    station.all.average(:longitude).to_i || station.first.longitude.to_i
  end

  def latitude
    station.all.average(:latitude).to_i || station.first.latitude.to_i
  end
end
