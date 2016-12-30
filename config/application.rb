require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Use dotenv to load secrets
Dotenv::Railtie.load unless Rails.env.production?

HOSTNAME = ENV['HOSTNAME']

module TeamThrive
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified 
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.exceptions_app = self.routes
  end
end
