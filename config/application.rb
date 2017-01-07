require_relative 'boot'

require 'rails/all'
require 'date'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Use dotenv to load secrets
Dotenv::Railtie.load unless Rails.env.production?

HOSTNAME = ENV['HOSTNAME']

module TeamThrive
  class Application < Rails::Application
    # Allow custom error pages
    config.exceptions_app = self.routes

    # Include the authenticity token in remote forms
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
