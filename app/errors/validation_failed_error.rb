# typed: true
# frozen_string_literal: true

class ValidationFailedError < ResourceError
  attr_reader :resource

  def initialize(msg = nil, resource: nil, **options)
    @resource = resource
    options[:error] = map_resource_errors
    super
  end

  def message
    'Validation failed'
  end

  def code
    :validation_failed
  end

  def to_json(*)
    base = {
      code: code,
      error: map_resource_errors || { camelize_key(code).to_sym => { message: msg } }
    }
    Rails.env.production? ? base : merge_details(base)
  end

  def map_resource_errors
    return unless resource&.respond_to?(:errors)

    error = {}
    resource.errors.messages.each_pair do |key, val|
      error[camelize_key(key)] = { message: val.join(', ') }
    end
    error
  end

  def camelize_key(key)
    base = key.to_s.camelcase
    base[0].downcase + base[1..-1]
  end
end
