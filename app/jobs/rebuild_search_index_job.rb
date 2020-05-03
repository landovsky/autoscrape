# typed: false
# frozen_string_literal: true

class RebuildSearchIndexJob < ApplicationJob
  queue_as :rebuild_index

  def self.perform_or_replace_next(wait_until: Time.zone.now)
    existing_job = DelayedJob.rebuild_index.not_failed.first
    existing_job&.destroy

    set(wait_until: wait_until).perform_later
  end

  def perform
    DenormalizedProduct.rebuild_index
  end
end
