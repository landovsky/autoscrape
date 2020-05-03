# typed: strong
# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include NormalizeBlankValues

  self.abstract_class = true
end
