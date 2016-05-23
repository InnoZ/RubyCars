require 'ruby_cars_log'
module RubyCars
  class Autolib < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'autolib',
          provider_name: 'Autolib',
          provider_id: 'autolib',
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
      'https://www.autolib.eu/stations/'
    end
  end
end
