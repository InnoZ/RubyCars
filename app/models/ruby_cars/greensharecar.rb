require_relative '../ruby_cars_log'
module RubyCars
  class Greensharecar < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: provider_name.downcase,
          provider_name: provider_name,
          provider_id: provider_name.downcase,
          latitude: Float(station.fetch('latitude')),
          longitude: Float(station.fetch('longitude')),
          cars: Integer(station.fetch('vehicles').split(',').length),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page[/var vicCars \= (\[.*\])/, 1])
    end

    def provider_name
      'Greensharecar'
    end

    private

    def page
      log_request(url) do
        Mechanize.new.get_file(url)
      end
    end

    def url
      'http://www.greensharecar.com.au/cars-and-locations/'
    end
  end
end
