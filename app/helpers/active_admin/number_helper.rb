# typed: false
# frozen_string_literal: true

# restart server after registering new helper

module ActiveAdmin
  module NumberHelper
    def base_number(number, precision: 0)
      num = number_with_precision(number, precision: precision)
      number_with_delimiter(num, delimiter: ' ', separator: ',')
    end

    def currency(number, currency = nil, precision: 0, unit: nil)
      num = base_number(number, precision: precision)
      [num, currency_unit_formatter(currency, unit)].compact.join(' ')
    end

    def currency_unit_formatter(currency, unit)
      [currency, unit].compact.join(' / ')
    end

    def percentage(number, precision: 2)
      return unless number

      base_number(number, precision: precision) + '%'
    end
  end
end
