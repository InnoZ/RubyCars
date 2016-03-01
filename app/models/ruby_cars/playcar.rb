module RubyCars
  class Playcar < Base
    # rubocop:disable MethodLength
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'playcar',
          provider_name: 'Playcar',
          provider_id: 'playcar',
          latitude: Float(station.fetch('latitude')),
          longitude: Float(station.fetch('longitude')),
          cars: Integer(station.fetch('vehicles').split(',').length),
          extra: {
            'address' => station.fetch('descr'),
            'uid' => station.fetch('id'),
          },
        ).run
      end
    end

    def stations
      page = agent.post(url, query, header)
      JSON.parse(page.body)
    end

    def agent
      agent = Mechanize.new
      agent.get(cookie_url)
      agent
    end

    private

    def header
      {
        'Cookie' => "sid=#{cookie}"
      }
    end

    def cookie
      agent.cookies.first.value
    end

    def query
      {
        'markets' => '1'
      }
    end

    def url
      'https://prenota.playcar.net/maps/api/lots.php'
    end

    def cookie_url
      'https://prenota.playcar.net/maps/'
    end
  end
end
