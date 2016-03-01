class StationsController < ApplicationController
  # rubocop:disable MethodLength
  def index
    @regions = Region.all.sort
    @providers_in_region = providers_in_region
    @regions_geojson = @regions.map { |p| RegionSerializer.new(p).geojson }
  end

  # rubocop:disable Metrics/AbcSize
  def show
    @regions = Region.all.sort
    @providers_in_region = providers_in_region
    @stations_geojson = stations.map { |s| StationSerializer.new(s).geojson }
  end

  private

  def stations
    if params[:provider]
      stations_in_region.where(provider_id: params[:provider])
    else
      stations_in_region
    end
  end

  def stations_in_region
    Station.where(region_id: params[:region])
  end

  def providers_in_region
    stations_in_region.map do |station|
      station.provider
    end.uniq
  end

  def provider_id(provider)
    Provider.find_by(name: provider).id
  end
end
