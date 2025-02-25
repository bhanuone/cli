# frozen_string_literal: true

require "rack"
require_relative "../app"
require_relative "../../server"

module Hanami
  module CLI
    module Commands
      module App
        # Launch Hanami web server.
        #
        # It's intended to be used only on development. For production, you
        # should use the rack handler command directly (i.e. `bundle exec puma
        # -C config/puma.rb`).
        #
        # The server is just a thin wrapper on top of Rack::Server. The options that it
        # accepts fall into two different categories:
        #
        # - When not explicitly set, port and host are not passed to the rack
        # server instance. This way, they can be configured through the
        # configured rack handler (e.g., the puma configuration file).
        #
        # - All others are always given by the Hanami command.
        #
        # Run `bundle exec hanami server -h` to see all the supported options.
        class Server < Command
          DEFAULT_PORT = 2300
          private_constant :DEFAULT_PORT

          desc "Start Hanami server"

          option :host, default: nil, required: false,
                        desc: "The host address to bind to (falls back to the rack handler)"
          option :port, default: DEFAULT_PORT, required: false,
                        desc: "The port to run the server on (falls back to the rack handler)"
          option :config, default: "config.ru", required: false, desc: "Rack configuration file"
          option :debug, default: false, required: false, desc: "Turn on/off debug output", type: :boolean
          option :warn, default: false, required: false, desc: "Turn on/off warnings", type: :boolean

          def initialize(server: Hanami::CLI::Server.new)
            super()
            @server = server
          end

          # @api private
          def call(port: DEFAULT_PORT, **kwargs)
            server.call(port: port, **kwargs)
          end

          private

          attr_reader :server
        end
      end
    end
  end
end
