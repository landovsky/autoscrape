class Crawl < ApplicationRecord
  belongs_to :car, touch: :last_seen

  enum format: { html: 1, json: 2 }

  scope :last_change, -> { where('crawls.id IN (SELECT MAX(crawls.id) from crawls GROUP BY car_id)')
                           .order('crawls.created_at DESC') }
  scope :parsed, -> { where('parsed_at < ?', Time.zone.now) }
  scope :unparsed, -> { where(parsed_at: nil) }

  def parsed!
    update parsed_at: Time.zone.now
  end

  def parse_body
    @parse_body ||= JSON.parse body.gsub('=>', ':')
  end

  def find_key(key)
    parse_body.keys.select { |k, _v| k.include? key }
  end
end
