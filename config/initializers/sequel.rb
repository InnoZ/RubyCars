RUBYCARS_ENV = ENV.fetch('RAILS_ENV') { 'development' }
database_url = format('postgres:///rubycars_%s', RUBYCARS_ENV)
DB = Sequel.connect(database_url)
