module RubyCars
  class Dummy < Base
    def run
      stations.each do |station|
        RubyCars::Importer.new(
          company_id: 'dummy_company',
          provider_name: 'Dummy Cars',
          provider_id: 'dummy_cars',
          latitude: Float(station.fetch('latitude')),
          longitude: Float(station.fetch('longitude')),
          cars: Integer(station.fetch('vehicles').length),
          extra: {},
        ).run
      end
    end

    def stations
      JSON.parse(Nokogiri::HTML(open('dummy.php')))
    end
  end
end
