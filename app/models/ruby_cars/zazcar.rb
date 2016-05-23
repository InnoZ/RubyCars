require 'ruby_cars_log'
module RubyCars
  class Zazcar < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'zazcar',
          provider_name: 'Zazcar',
          provider_id: 'zazcar',
          latitude: Float(station.fetch('latitude')),
          longitude: Float(station.fetch('longitude')),
          cars: Integer(station.fetch('vehicles').split(',').length),
          extra: {},
        ).run
      end
    end

    def stations
      log_request(url) do
        page = agent.post(url, query, header)
        JSON.parse(page.body)
      end
    end

    def agent
      agent = Mechanize.new
      agent.get(cookie_url)
      agent
    end

    def provider_name
      'Zazcar'
    end

    private

    def header
      {
        'Cookie' => "sid=#{cookie}",
      }
    end

    def cookie
      agent.cookies.first.value
    end

    def query
      {
        'markets' => '1',
      }
    end

    def url
      'https://reserva.zazcar.com.br/maps/api/lots.php'
    end

    def cookie_url
      'https://www.zazcar.com.br/localidades'
    end
  end
end
