require_relative '../../app/models/ruby_cars/base.rb'

desc 'Scrape all Providers'
task scrape: [:environment] do
  InfiniteLoop.new.run
end

namespace :scrape do
  desc 'Delete all Stations'
  task delete_all_stations: [:environment] do
    Station.delete_all
  end

  desc 'Delete all Providers'
  task delete_all_providers: [:environment] do
    Provider.delete_all
  end

  RubyCars::Base.all.each do |subclass|
    desc "Scrape the provider #{subclass.name}"
    task subclass.name.to_sym => [:environment] do
      subclass.new.run
    end
  end
end
