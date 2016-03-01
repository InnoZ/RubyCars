module RubyCars
  class Importer
    require 'digest'

    # rubocop:disable ParameterLists
    def initialize(company_id:, provider_name:, provider_id:, latitude:, longitude:, cars:, extra:)
      @company_id = company_id
      @provider_name = provider_name
      @provider_id = provider_id
      @latitude = latitude
      @longitude = longitude
      @cars = cars
      @extra = extra
    end

    attr_accessor :company_id, :provider_name, :provider_id, :latitude, :longitude, :cars, :extra, :geocoded_region

    def run
      if in_admin_area?
        @id ||= id
        if Station.find_by(id: id)
          update_station(id)
        else
          create_parents
          create_station(id)
        end
        update_provider_centroid
      end
    end

    private

    def in_admin_area?
      !(geocoded_region.nil?) &&
        #exception for test polygon 'Null Island'
        (latitude != 0 || longitude != 0)
    end

    def create_parents
      if company.nil?
        create_company
      end
      if provider.nil?
        create_provider
      end
      if region.nil?
        create_region
      end
    end

    def region
      Region.find_by(id: geocoded_region)
    end

    def company
      Company.find_by(id: company_id)
    end

    def provider
      Provider.find_by(id: provider_id)
    end

    def create_region
      Region.create(id: geocoded_region)
    end

    def create_company
      Company.create(id: company_id)
    end

    def create_provider
      Provider.create(
        company_id: company_id,
        name: provider_name,
        id: provider_id,
        extra: extra,
      )
    end

    def geocoded_region
      @geocoded_region ||= Geocoder.new(latitude, longitude).region
    end

    def update_provider_centroid
      latitude = provider.station.average(:latitude)
      longitude = provider.station.average(:longitude)
      provider.update!(
        centroid_latitude: latitude,
        centroid_longitude: longitude,
      )
    end

    def create_station(id)
      provider.station.create(
        id: id,
        region_id: geocoded_region,
        latitude: latitude,
        longitude: longitude,
        cars: cars,
      )
    end

    def update_station(id)
      provider.station
        .find_by(id: id)
        .update_attributes!(
          cars: cars,
          updated_at: Time.now.utc,
        )
    end

    def id
      md5 = Digest::MD5.new
      string_to_encode = "#{provider_id} #{latitude * 1E6} #{longitude * 1E6}"
      md5.update string_to_encode
      md5.hexdigest
    end
  end
end
