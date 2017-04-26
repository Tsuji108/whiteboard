# frozen_string_literal: true
Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.serve_static_assets = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :scss
  config.assets.compile = true
  config.assets.digest = true
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.action_mailer.perform_caching = false

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  host = ENV['HOST']
  config.action_mailer.default_url_options = { host: host, protocol: 'https' }
  config.action_mailer.default_options = { from: ENV['FROM_ADDRESS'] }
  ActionMailer::Base.smtp_settings = {
    address: 'email-smtp.us-west-2.amazonaws.com',
    port: '587',
    authentication: :login,
    user_name: ENV['AMAZONSES_USERNAME'],
    password: ENV['AMAZONSES_PASSWORD'],
    enable_starttls_auto: true,
  }
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
end
