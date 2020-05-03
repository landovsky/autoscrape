class Crawl < ApplicationRecord
  belongs_to :car, touch: :last_seen
end
