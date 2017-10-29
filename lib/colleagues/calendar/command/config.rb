module Colleagues
  module Calendar
    module Command
      class ConfigParser

        attr_reader :client_id
        attr_reader :client_secret
        attr_reader :calendar_ids
        attr_reader :schedule_type
        attr_accessor :refresh_token

        def initialize
          begin
            config_path = File.expand_path("~/.colleagues-calendar-command.yaml")
            unless File.exist?(config_path)
              message =<<MESSAGES
Configuration file:<#{config_path}> not found.
Create #{config_path}.

  Example:
    ---
    calendar_ids:
      John Smith: john@example.com

MESSAGES
              raise ConfigurationError, message
            end
            @conf = YAML.load_file(config_path)
            @calendar_ids = @conf["calendar_ids"]
            @schedule_type = @conf["schedule_type"]
            @refresh_token = @conf["refresh_token"]

            secret_path = File.expand_path("~/.colleagues-calendar-command.secret.json")
            unless File.exist?(secret_path)
              message =<<MESSAGES
Client secret file:<#{secret_path}> not found.

  1. Create project on https://console.developers.google.com/ for Google Calendar API
  2. Download credential(OAuth client ID) file.

MESSAGES
              raise ConfigurationError, message
            end
            open(secret_path) do |file|
              @secret = JSON.load(file)
              @client_id = @secret["installed"]["client_id"]
              @client_secret = @secret["installed"]["client_secret"]
            end
          rescue => e
            puts e.message
            exit 1
          end
        end

        def save
          @conf["refresh_token"] = @refresh_token
          config_path = File.expand_path("~/.colleagues-calendar-command.yaml")
          open(config_path, "w") do |file|
            file.puts(YAML.dump(@conf))
          end
        end
      end
    end
  end
end
