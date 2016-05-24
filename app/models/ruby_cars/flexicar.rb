require_relative '../ruby_cars_log'
module RubyCars
  class Flexicar < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: provider_name.downcase,
          provider_name: provider_name,
          provider_id: provider_name.downcase,
          latitude: Float(station.fetch('lat')),
          longitude: Float(station.fetch('lng')),
          cars: Integer(station.fetch('num')),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page[/markers \= (\[.*\])/, 1])
    end

    def provider_name
      'Flexicar'
    end

    private

    def page
      log_request(url) do
        Mechanize.new.get_file(url)
      end
    end

    def url
      'http://flexicar.com.au/cars-locations/locations/'
    end
  end
end
