require_relative '../ruby_cars_log'
module RubyCars
  class Matcha < Base
    CITIES = %w[
      Berlin
      Brussels
      Hamburg
      London
      Paris
    ]

    def run
      cities.map(&:run).flatten
    end

    def cities
      CITIES.map { |city| City.new(city) }
    end

    class City
      include RubyCarsLog
      def initialize(city)
        @city = city
      end

      def run
        stations.fetch('result').each do |station|
          RubyCars::Importer.new(
            company_id: 'matcha',
            provider_name: provider_name,
            provider_id: 'matcha',
            latitude: Float(station.fetch('latitude')),
            longitude: Float(station.fetch('longitude')),
            cars: Integer(station.fetch('numbercars')),
            extra: {},
          ).run
        end
      end

      def stations
        JSON.parse(page)
      end

      def provider_name
        'Matcha'
      end

      private

      attr_reader :city

      def stations
        log_request(url) do
          agent = Mechanize.new
          page = agent.post(url, query, {})
          JSON.parse(page.body)
        end
      end

      def query
        {
          'submitCity' => 'true',
          'carcity' => "#{city}",
          'language' => 'en',
        }
      end

      def url
        'http://www.drive-matcha.de/car-search'
      end
    end
  end
end
