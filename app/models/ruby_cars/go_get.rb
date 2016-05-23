require 'ruby_cars_log'
module RubyCars
  class GoGet < Base
    include RubyCarsLog
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: provider_name.downcase,
          provider_name: provider_name,
          provider_id: provider_name.downcase,
          latitude: Float(station.fetch('lat')),
          longitude: Float(station.fetch('lon')),
          cars: Integer(station.fetch('vehicles').length),
          extra: {},
        ).run
      end
    end

    def stations
      log_request(url) do
        agent = Mechanize.new
        page = agent.post(url, query, header)
        JSON.parse(page.body)
      end
    end

    def provider_name
      'GoGet'
    end

    private

    def header
      {
        'Cookie' => "PHPSESSID=#{cookie}",
      }
    end

    def cookie
      agent = Mechanize.new
      agent.get(url)
      agent.cookies.first.value
    end

    def query
      {
        'action' => 'pods',
      }
    end

    def url
      'https://www.goget.com.au/wp-admin/admin-ajax.php'
    end
  end
end
