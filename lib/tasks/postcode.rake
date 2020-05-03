# frozen_string_literal: true

namespace :postcode do
  task rebuild: :environment do |_env|
    PostcodeService.rebuild_db
  end
end
