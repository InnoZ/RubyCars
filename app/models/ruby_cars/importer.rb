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
      @id ||= id
      if Station.find_by(id: id)
        update_station(id)
      else
        create_parents
        create_station(id)
      end
      update_provider_centroid if in_admin_area?
    end

    private

    def in_admin_area?
      !(geocoded_region.nil?) &&
        # exception for test polygon 'Null Island'
        (latitude != 0 || longitude != 0)
    end

    def create_parents
      create_company if company.nil?
      create_provider if provider.nil?
      create_region if region.nil?
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
      if expired_date?(id)
        provider.station.find_by(id: id).destroy
      else
        provider.station
          .find_by(id: id)
          .update_attributes!(
            cars: cars,
            updated_at: Time.now.utc,
          )
      end
    end

    def expired_date?(id)
      timestamp = provider.station.where(id: id).first[:updated_at]
      date = Date.new(timestamp.year, timestamp.month, timestamp.day)
      current_date = Date.today

      return true if Integer(current_date - date) > 30
      false
    end

    def id
      md5 = Digest::MD5.new
      string_to_encode = "#{provider_id} #{latitude * 1E6} #{longitude * 1E6}"
      md5.update string_to_encode
      md5.hexdigest
    end
  end
end
