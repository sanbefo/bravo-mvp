require "sidekiq/api"

namespace :sidekiq do
  desc "Clear all Sidekiq queues"

  task clear: :environment do
    puts "Clearing Sidekiq queues..."

    Sidekiq::Queue.all.each(&:clear)
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
    Sidekiq::DeadSet.new.clear

    puts "Done."
  end
end
