require_relative '../ruby_cars_log'
module RubyCars
  class Guidami < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: provider_name.downcase,
          provider_name: provider_name,
          provider_id: provider_name.downcase,
          latitude: Float(station.fetch('lat')),
          longitude: Float(station.fetch('lon')),
          cars: Integer(station.fetch('n_posti')),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page[/var\ \locations\ \= (\[.*\])/, 1])
    end

    def provider_name
      'Guidami'
    end

    private

    def page
      log_request(url) do
        Mechanize.new.get_file(url)
      end
    end

    def url
      'http://www.guidami.net/it/milano/parking'
    end
  end
end
