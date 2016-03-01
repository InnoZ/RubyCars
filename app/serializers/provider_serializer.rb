class ProviderSerializer < ActiveModel::Serializer
  def geojson
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [object.centroid_longitude, object.centroid_latitude]
      },
      properties: {
        provider_name: object.name,
        stations: object.station.count,
        country: object.region_id,
        last_update: object.updated_at.to_s,
      }
    }
  end
end
