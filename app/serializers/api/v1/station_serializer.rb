class Api::V1::StationSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :cars, :updated_at
end
