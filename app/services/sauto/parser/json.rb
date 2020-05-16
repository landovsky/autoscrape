module Sauto
  module Parser
    class JSON
      attr_reader :json

      def initialize(json, force_parsing: false)
        @json = json
        @force_parsing = force_parsing
      end

      def self.call(json)
        new(json).to_params
      end

      def to_params
        {
          created_at: Date.parse(json['advert_since']),
          source: :sauto,
          location: json['advert_locality_city'],
          title: [json['manufacturer_name'], json['model_name'], json['advert_name']].join(' '),
          odometer: json['advert_tachometr'],
          transmission: json['advert_gearbox_cb'] == 1 ? :manual : :automatic,
          fuel: json['advert_fuel_cb'] == 1 ? :petrol : (json['advert_fuel_cb'] == 2 ? :diesel : :other)
        }
      end
    end
  end
end