require_relative '../ruby_cars_log'
module RubyCars
  class Bluely < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'bluely',
          provider_name: 'Bluely',
          provider_id: 'bluely',
          latitude: Float(station.fetch('lat')),
          longitude: Float(station.fetch('lng')),
          cars: Integer(station.fetch('cars')),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page[/initMap\((\[.*\]),/, 1])
    end

    private

    def page
      log_request(url) do
        Mechanize.new.get_file(url)
      end
    end

    def url
      'https://www.bluely.eu/stations/'
    end
  end
end
