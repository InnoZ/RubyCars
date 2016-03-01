class Api::V1::ProviderOverviewSerializer < ActiveModel::Serializer

  attributes :name, :stations, :href

  def stations
    object.station.count
  end

  def href
    "/v1/providers/#{object.id}"
  end
end
