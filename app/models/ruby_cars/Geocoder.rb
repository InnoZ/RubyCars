class Geocoder
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
    @admin_area = closest
  end

  attr_reader :latitude, :longitude, :admin_area

  def region
    return nil if admin_area.nil?
    append('United States of America', :region) ||
      append('China', :name) ||
      append('Australia', :name) ||
      append('Russia', :region) ||
      append('Canada', :region) ||
      admin_area.fetch(:admin)
    end

  private

  def append(country, attribute)
    "#{country} (#{admin_area.fetch(attribute)})" if admin_area.fetch(:admin) == country
  end

  def closest
    location = "st_setsrid(st_point(#{longitude}, #{latitude}), 4326)"
    query(location)
  end

  def query(location)
    DB[ <<-SQL
      SELECT a.*
      FROM admin_areas a
      WHERE ST_DWithin(a.geom, #{location}, 0.3) 
      ORDER BY ST_Distance(a.geom, #{location})
      SQL
    ].first
  end
end
