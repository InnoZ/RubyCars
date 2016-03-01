class StationSerializer < ActiveModel::Serializer
  def geojson
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [object.longitude, object.latitude]
      },
      properties: {
        provider_name: provider_name,
        cars: object.cars,
        last_update: object.updated_at.to_s,
      }
    }
  end

  # to avoid loading provider for each record, name is generated from id
  def provider_name
    object.provider_id.titleize
  end
end
