# frozen_string_literal: true

namespace :search_index do
  task rebuild: :environment do |_env|
    DenormalizedProduct.rebuild_index
  end
end
