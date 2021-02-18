namespace :products do
  task :ping, [] => :environment do
    TaskHelpers::Products.ping
  end
end
