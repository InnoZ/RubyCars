module RubyCars
  class Carrot < Base
    # rubocop:disable MethodLength
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'carrot',
          provider_name: 'Carrot',
          provider_id: 'carrot',
          latitude: Float(station.fetch('latitude')),
          longitude: Float(station.fetch('longitude')),
          cars: Integer(station.fetch('vehicles').split(',').length),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page)
    end

    private

    def page
      Mechanize.new.get_file(url)
    end

    def url
      "https://reserva.carrot.mx/maps/api/lots.php?#{query}"
    end

    def query
      'markets=1%2C2%2C3%2C4'
    end
  end
end
