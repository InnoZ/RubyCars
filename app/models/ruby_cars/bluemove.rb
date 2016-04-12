require 'ruby_cars_log'
module RubyCars
  class Bluemove < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: provider_name.downcase,
          provider_name: provider_name,
          provider_id: provider_name.downcase,
          latitude: Float(station.fetch('gpslat')),
          longitude: Float(station.fetch('gpslong')),
          cars: Integer(station.fetch('vehicles').length),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page[/var\ \locations\ \= (\[.*\])/, 1])
    end

    def provider_name
      'Bluemove'
    end

    private

    def page
      log_request(url) do
        Mechanize.new.get_file(url)
      end
    end

    def url
      'https://bluemove.es/en/map-vehicles'
    end
  end
end
