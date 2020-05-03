class Crawl < ApplicationRecord
  belongs_to :car, touch: :last_seen

  scope :parsed, -> { where('parsed_at < ?', Time.zone.now) }
  scope :unparsed, -> { where(parsed_at: nil) }

  def parsed!
    update parsed_at: Time.zone.now
  end
end
