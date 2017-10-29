# coding: utf-8
module Colleagues
  module Calendar
    module Command

      class Calendar
        attr_accessor :refresh_token

        def initialize(client_id, client_secret, calendar_id, refresh_token = nil)
          @calendar = Google::Calendar.new(:client_id     => client_id,
                                     :client_secret => client_secret,
                                     :calendar      => calendar_id,
                                     :redirect_url  => "urn:ietf:wg:oauth:2.0:oob")
          @refresh_token = refresh_token
        end

        def renew_refresh_token
          puts "以下のURLをブラウザで開き、アクセスを承認してください。:"
          puts @calendar.authorize_url
          puts "リフレッシュトークンを入力してください。:"
          @refresh_token = @calendar.login_with_auth_code($stdin.gets.chomp)
          @refresh_token
        end

        def create_all_day(title,
                           begin_time,
                           end_time)
          check_refresh_token
          event = @calendar.create_event do |e|
            e.title = title
            e.start_time = begin_time
            e.end_time = end_time
            e.all_day = begin_time
          end
          event
        end

        def create_event(title,
                         begin_time,
                         end_time)
          check_refresh_token
          event = @calendar.create_event do |e|
            e.title = title
            e.start_time = begin_time
            e.end_time = end_time
          end
          event
        end

        private

        def check_refresh_token
          unless @refresh_token
            @refresh_token = renew_refresh_token
          end
          @calendar.login_with_refresh_token(@refresh_token)
        end
      end
    end
  end
end
      
