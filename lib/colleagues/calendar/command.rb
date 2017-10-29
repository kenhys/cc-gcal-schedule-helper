# coding: utf-8
require "optparse"
require "highline"
require "yaml"
require "google_calendar"
require "colleagues/calendar/command/version"
require "colleagues/calendar/command/config"
require "colleagues/calendar/command/calendar"

module Colleagues
  module Calendar
    module Command

      class ConfigurationError < StandardError; end
      
      class CommandLine

        def initialize
          @config = ConfigParser.new
        end

        def select_calendar
          selection = {}
          @cli.choose do |menu|
            menu.prompt = "誰のカレンダーに登録しますか？"
            @config.calendar_ids.keys.each do |key|
              menu.choice(key) do |person|
                calendar_id = @config.calendar_ids[person]
                selection[:person] = person
                selection[:calendar_id] = calendar_id
              end
            end
          end
          selection
        end

        def select_schedule_type
          schedule_type = ""
          @cli.choose do |menu|
            menu.prompt = "登録する予定の種類は？"
            @config.schedule_type.each do |type, item|
              menu.choice(item["label"]) do |selected|
                schedule_type = selected
              end
            end
          end
          schedule_type
        end

        def input_schedule_date(schedule_type)
          message =<<SCHEDULE
#{schedule_type}ですね。登録予定の日時は？
  入力例:
  11/29 (全休などの場合)
  10:00 - 11:00 (当日の予定の場合)
  11/29 10:00 - 11/29 11:00 (他の日の予定の場合)

SCHEDULE
          input = @cli.ask(message)
          begin_time = Time.now
          end_time = Time.now
          begin
            if input.index("-")
              begin_time = Time.parse(input.split("-")[0])
              end_time = Time.parse(input.split("-")[1])
            else
              begin_time = Time.parse(input)
              end_time = begin_time + (60 * 60 * 24)
            end
          rescue
            p "FAIL"
            return
          end
          [begin_time, end_time]
        end
        
        def run(arguments)
          @cli = HighLine.new
          calendar_selection = select_calendar
          @calendar_id = calendar_selection[:calendar_id]
          schedule_type = select_schedule_type
          schedule_date = input_schedule_date(schedule_type)
          register_event(schedule_type, schedule_date[0], schedule_date[1]) 
          true
        end

        def register_event(schedule_type, begin_time, end_time)
          @config.schedule_type.each do |key, item|
            if item["label"] == schedule_type
              if item["all_day"]
                register_all_day_event("#{item["text"]}", begin_time, end_time)
              else
                register_oneshot_event("#{item["text"]}", begin_time, end_time)
              end
            end
          end
        end

        def register_all_day_event(title, begin_time, end_time)
          begin
            @calendar = Calendar.new(@config.client_id,
                                     @config.client_secret,
                                     @calendar_id,
                                     @config.refresh_token)
            @calendar.create_all_day(title,
                                     begin_time,
                                     end_time)
            unless @config.refresh_token
              @config.refresh_token = @calendar.refresh_token
              @config.save
            end
            @cli.say("登録を完了しました。")
          rescue => e
            puts e.message
            exit 1
          end
        end

        def register_oneshot_event(title, begin_time, end_time)
          begin
            @calendar = Calendar.new(@config.client_id,
                                     @config.client_secret,
                                     @calendar_id,
                                     @config.refresh_token)
            @calendar.create_event(title,
                                   begin_time,
                                   end_time)
            unless @config.refresh_token
              @config.refresh_token = @calendar.refresh_token
              @config.save
            end
            @cli.say("登録を完了しました。")
          rescue => e
            puts e.message
            exit 1
          end
        end
      end
    end
  end
end
