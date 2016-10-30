Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX


  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "rubymeetup-example-relative-time_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address: ENV['SPARKPOST_SMTP_HOST'],
    port: ENV['SPARKPOST_SMTP_PORT'], # ports 587 and 2525 are also supported with STARTTLS
    enable_starttls_auto: true, # detects and uses STARTTLS
    user_name: ENV['SPARKPOST_SMTP_USERNAME'],
    password: ENV['SPARKPOST_SMTP_PASSWORD'], # SMTP password is any valid API key
    authentication: 'login', # Mandrill supports 'plain' or 'login'
    domain: 'prokopsimek.cz', # your domain to identify your server when connecting
  }

  unless ENV['TIME_SCALE'].blank?
    # 3600: 1 day == 24 sec
    # 1440: 1 day == 1 minute
    # 24:   1 day == 1 hour
    # 12:   1 day == 2 hours
    # 6:    1 day == 4 hours
    # 3:    1 day == 8 hours
    time_scale = (ENV['TIME_SCALE']).to_f
    config.after_initialize do
      set_to_time = Redis.new.get('current_testing_time')
      $stderr.puts "REDIS set_to_time: #{set_to_time}"
      Timecop.travel(set_to_time) if set_to_time.present?
      Timecop.scale(time_scale)
    end

    Sidekiq.schedule = YAML.load_file(File.expand_path(Rails.root + 'config/scheduler.yml', __FILE__))
    Sidekiq::Scheduler.enabled = true
    Sidekiq::Scheduler.reload_schedule!

    $stderr.puts "TIME_SCALE: #{time_scale} @ #{Time.now.to_s}"
  end
end
