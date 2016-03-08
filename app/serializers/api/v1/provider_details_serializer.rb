class Api::V1::ProviderDetailsSerializer < ActiveModel::Serializer
  attributes :id, :name, :centroid_longitude, :centroid_latitude, :href, :stations

  # has_many :station, serializer: Api::V1::StationSerializer
  # To get the plural key 'stations', the method below has to be used instead
  def stations
    ActiveModel::ArraySerializer.new(object.station, each_serializer: Api::V1::StationSerializer)
  end

  def href
    "/v1/providers/#{object.id}"
  end
end
