require_relative '../ruby_cars_log'
module RubyCars
  class Zipcar < Base
    # cities with Zipcar-operations are described here with the format
    # [latitude & longitude (both decimal degree), city (string, as stated by the provider),
    # latitude delta & longitude delta (to define bounding box, also both in decimal degree)]
    MARKETS = [
      [43.526304, 5.445429, 'Aix-en-Provence', 0.25, 0.45],
      [43.948611, 4.808333, 'Avignon', 0.55, 0.90],
      [41.41, 2.17, 'Barcelona', 0.55, 0.90],
      [44.837778, -0.579444, 'Bordeaux', 0.55, 0.90],
      [47.505, 9.749167, 'Bregenz', 0.25, 0.45],
      [51.4546, -2.5879, 'Bristol', 0.55, 0.90],
      [52.2, 0.116667, 'Cambridge', 0.55, 0.90],
      [43.5525, 7.021667, 'Cannes', 0.25, 0.45],
      [55.95, -3.216667, 'Edinburgh', 0.55, 0.90],
      [47.238056, 9.598333, 'Feldkirch', 0.25, 0.45],
      [50.110556, 8.682222, 'Frankfurt', 0.55, 0.90],
      [55.858, -4.259, 'Glasgow', 0.55, 0.90],
      [47.066667, 15.433333, 'Graz', 0.55, 0.90],
      [47.267222, 11.392778, 'Innsbruck', 0.55, 0.90],
      [41.01, 28.96, 'Istanbul', 0.55, 0.90],
      [50.6278, 3.0583, 'Lille', 0.55, 0.90],
      [48.3, 14.283333, 'Linz/Wels', 0.55, 0.90],
      [51.50939, -0.11832, 'London', 0.55, 0.90],
      [43.033333, -81.15, 'London Ontario', 0.55, 0.90],
      [45.76, 4.84, 'Lyon', 0.55, 0.90],
      [40.4125, -3.703889, 'Madrid', 0.55, 0.90],
      [51.273611, 0.522778, 'Maidstone', 0.25, 0.45],
      [43.296667, 5.376389, 'Marseille', 0.25, 0.45],
      [47.217222, -1.553889, 'Nantes', 0.55, 0.90],
      [43.7034, 7.2663, 'Nice', 0.25, 0.45],
      [45.411556, -75.698444, 'Ottawa', 0.55, 0.90],
      [51.752, -1.2578, 'Oxford', 0.55, 0.90],
      [47.8, 13.033333, 'Salzburg', 0.55, 0.90],
      [48.583611, 7.748056, 'Strasbourg', 0.55, 0.90],
      [48.204722, 15.626667, '', 0.25, 0.45],
      [43.66135, -79.383087, 'Toronto', 0.55, 0.90],
      [43.6045, 1.444, 'Toulouse', 0.55, 0.90],
      [49.28098, -123.12244, 'Vancouver', 0.55, 0.90],
      [48.422, -123.365, 'Victoria', 0.55, 0.90],
      [43.466667, -80.516667, 'Waterloo', 0.55, 0.90],
      [48.2, 16.366667, 'Wien/St. Pölten', 0.55, 0.90],
    ]

    def run
      markets.map(&:run).flatten
    end

    def markets
      MARKETS.map { |lat, lon, city, lat_delta, lon_delta| Market.new(lat, lon, city, lat_delta, lon_delta) }
    end

    class Market
      include RubyCarsLog
      def initialize(lat, lon, city, lat_delta, lon_delta)
        @lat = lat
        @lon = lon
        @city = city
        @lat_delta = lat_delta
        @lon_delta = lon_delta
      end

      def run
        return unless stations.key?('locations')
        name = "Zipcar #{city}"
        stations.fetch('locations').each do |station|
          RubyCars::Importer.new(
            company_id: 'zipcar',
            provider_name: name,
            provider_id: name.parameterize.underscore,
            latitude: Float(station.fetch('latitude')),
            longitude: Float(station.fetch('longitude')),
            cars: Integer(station.fetch('vehicleCount')),
            extra: {},
          ).run
        end
      end

      def stations
        JSON.parse(page)
      end

      private

      attr_reader :lat, :lon, :city, :lat_delta, :lon_delta

      def page
        log_request(url) do
          Mechanize.new.get_file(url)
        end
      end

      # rubocop:disable LineLength
      def url
        "http://www.zipcar.com/api/drupal/1.0/locations?lat=#{lat}&lon=#{lon}&lat_delta=#{lat_delta}&lon_delta=#{lon_delta}&locale=en-US"
      end
    end
  end
end
