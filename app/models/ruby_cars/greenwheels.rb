module RubyCars
  class Greenwheels < Base
    COUNTRIES = %w[de nl]

    def run
      countries.map(&:run).flatten
    end

    def countries
      COUNTRIES.map { |country| Country.new(country) }
    end

    class Country
      attr_reader :country

      def initialize(country)
        @country = country
      end

      def country_name
        case country
        when 'de' then 'Germany'
        when 'nl' then 'Netherlands'
        end
      end

      def collect
        results = []
        stations.each do |station|
          station.fetch('locations').each do |attributes|
            results << [station.fetch('name'),
                        attributes.fetch('geo').first,
                        attributes.fetch('geo').last,
                        attributes.fetch('cars')]
          end
        end
        results
      end

      def run
        collect.each do |station|
          RubyCars::Importer.new(
            company_id: 'greenwheels',
            provider_name: "Greenwheels #{country_name}",
            provider_id: "greenwheels #{country_name}".underscore,
            latitude: Float(station[1]),
            longitude: Float(station[2]),
            cars: Integer(station[3].length),
            extra: {},
          ).run
        end
      end

      def stations
        JSON.parse(page)
      end

      def page
        Mechanize.new.get_file(url)
      end

      def url
        "https://www.greenwheels.com/book/js/#{country}/citiesAndLocations/?_=1441696878911"
      end
    end
  end
end
