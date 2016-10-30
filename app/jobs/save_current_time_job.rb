class SaveCurrentTimeJob
  include Sidekiq::Worker

  def perform
    saved_time =  DateTime.parse(Redis.new.get('current_testing_time'))

    if saved_time < DateTime.now
      Redis.new.set('current_testing_time', DateTime.now)
    end
  end
end
