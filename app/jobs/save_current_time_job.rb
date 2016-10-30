class SaveCurrentTimeJob
  include Sidekiq::Worker

  def perform
    redis_time = Redis.new.get('current_testing_time')
    saved_time = DateTime.parse(redis_time) if redis_time.present?

    if saved_time.present? && saved_time < DateTime.now
      Redis.new.set('current_testing_time', DateTime.now)
    end
  end
end
