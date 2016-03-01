namespace :geocoder do
  task :prepare, [:database] => :environment do |task, args|
    DUMP_PATH = Rails.root.join('dumps', 'admin_areas.dump')
    puts "Importing osm dump into database #{args.with_defaults(database: 'rubycars_development')}"
    %x(psql -d #{args.database} < #{DUMP_PATH})
  end
end
