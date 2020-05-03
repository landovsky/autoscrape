# frozen_string_literal: true

class Seeder
  include Rake::DSL

  def init_factory_bot
    FactoryBot.register_strategy(:find_or_create, FactoryBot::Strategy::FindOrCreate)
    FactoryBot.find_definitions rescue FactoryBot::DuplicateDefinitionError
  end

  def create(*params)
    FactoryBot.create(*params)
  end

  def build(*params)
    FactoryBot.build(*params)
  end

  def find_or_create(*params)
    FactoryBot.find_or_create(*params)
  end

  def find_or_create_pair(*params)
    FactoryBot.find_or_create_pair(*params)
  end

  def initialize
    init_factory_bot

    namespace :seeder do
      task seed: :environment do |env|
        Rake::Task['db:create'].invoke
        Rake::Task['db:schema:load'].invoke
        Rake::Task['db:seed'].invoke
      end

      task base: :environment do |env|
        init_factory_bot
        create :product_complete
        DenormalizedProduct.rebuild_index
      end

      task model: :environment do |env|
        params = ENV['model'].split(':').map(&:to_sym)
        init_factory_bot
        record = FactoryBot.create(*params)
        puts record.as_json
      end

      task interactive: :environment do |env|
        init_factory_bot
        binding.pry
      end
    end
  end
end

if Rails.env.development? || Rails.env.test?
  require 'pry'

  require Rails.root.join('spec', 'support', 'factory_bot.rb')

  Seeder.new
end
