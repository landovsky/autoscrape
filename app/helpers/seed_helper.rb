# typed: true
# frozen_string_literal: true

module SeedHelper
  def self.seed(*class_name, &block)
    params    = block.parameters.collect { |i| i[1] }
    raw_items = yield
    model     = Object.const_get(class_name.map(&:to_s).map(&:camelize).join('::'))

    if params.count != raw_items.first.count
      raise ArgumentError, 'number of params does not match number of columns - ' \
                           "#{raw_items.first.count}: #{raw_items.first}\n" \
                           "#{params.count}: #{params}\n"
    end

    items = raw_items.map do |item|
      params.zip(item).to_h
    end

    begin
      objects = items.each { |item| model.new(item) }
      model.import objects
      puts "#{model.to_s.camelize.ljust(33)} #{objects.count.to_s.rjust(6)} items imported" if Rails.env.development?
    rescue => e
      raise TypeError, "Import failed for #{model.to_s.camelize}: #{e}"
    end
  end
end
