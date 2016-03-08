class RegionSerializer < ActiveModel::Serializer
  def geojson
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [object.longitude, object.latitude],
      },
      properties: {
        region: object.id,
        stations: object.stations,
      },
    }
  end
end
