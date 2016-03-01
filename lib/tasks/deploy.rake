namespace :deploy do
  desc 'Precompile assets and restart svc service'
  task uberspace: [:environment] do
    Rake::Task['assets:precompile'].invoke
    sh 'svc -du ~/service/rubycars/'
  end
end
