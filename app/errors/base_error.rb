# typed: true
# frozen_string_literal: true

class BaseError < StandardError
  attr_reader :code, :original_error, :msg, :options

  def initialize(msg = nil, **options)
    @msg            = msg
    @code           = options.delete(:code)
    @options        = options
    @original_error = options.delete(:error)

    Rails.logger.send(level, "#{self.class}: #{send(:code)}: #{send(:msg)} | #{send(:options)}")
    yield(@original_error || self) if block_given?
    super(msg)
  end

  def self.wrap(error)
    new(error.message, error: error, backtrace: error.backtrace)
  end

  def level
    :info
  end

  def error_backtrace
    backtrace || options[:backtrace] || original_error&.backtrace
  end

  def to_json(*)
    base = {
      code: code,
      error: { camelize_key(code).to_sym => { message: msg } }
    }
    Rails.env.production? ? base : merge_details(base)
  end

  private

  def merge_details(base_hash)
    base_hash.merge(options, backtrace: shortened_backtrace)
  end

  def shortened_backtrace
    error_backtrace&.take(20)&.push('...')
  end

  def camelize_key(key)
    base = key.to_s.camelcase
    base[0].downcase + base[1..-1]
  end
end
