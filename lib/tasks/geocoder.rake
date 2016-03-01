namespace :geocoder do
  task :prepare, [:database] => :environment do |_task, args|
    DUMP_PATH = Rails.root.join('dumps', 'admin_areas.dump')
    puts "Importing osm dump into database #{args.with_defaults(database: 'rubycars_development')}"
    "psql -d #{args.database} < #{DUMP_PATH}"
  end
end
