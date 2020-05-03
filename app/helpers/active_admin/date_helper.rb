# typed: true
# frozen_string_literal: true

# restart server after registering new helper

module ActiveAdmin
  module DateHelper
    def picker_datetime(date_time)
      parse_date_time(date_time).strftime('%Y-%m-%dT%H:%M')
    end

    def date_time(date_time)
      parse_date_time(date_time).strftime('%Y-%m-%d %H:%M')
    end

    def parse_date_time(date_time)
      date_time.is_a?(String) ? Time.zone.parse(date_time) : date_time
    end
  end
end
