require 'ruby_cars_log'
module RubyCars
  class Enterprise < Base
    include RubyCarsLog
    def run
      stations.fetch('lotdetailsList').each do |station|
        RubyCars::Importer.new(
          company_id: 'enterprise',
          provider_name: "Enterprise - #{station.fetch('instance')}",
          provider_id: "enterprise_#{station.fetch('instance').downcase}",
          latitude: Float(station.fetch('latitude')),
          longitude: Float(station.fetch('longitude')),
          cars: Integer(station.fetch('vehicleDetails').length),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page)
    end

    private

    def page
      log_request(url) do
        Mechanize.new.get_file(url)
      end
    end

    def url
      'https://www.enterprisecarshare.ca/content/ccw/services/carsharelocation.map.json'
    end
  end
end
