module RubyCars
  class Bluecub < Base
    # rubocop:disable MethodLength
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'bluecub',
          provider_name: 'Bluecub',
          provider_id: 'bluecub',
          latitude: Float(station.fetch('lat')),
          longitude: Float(station.fetch('lng')),
          cars: Integer(station.fetch('cars')),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(page[/initMap\((\[.*\]),/, 1])
    end

    private

    def page
      Mechanize.new.get_file(url)
    end

    def url
      'https://www.bluecub.eu/stations/'
    end
  end
end
