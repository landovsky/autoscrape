# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe Filter do
  describe 'check_unique_group_default validation' do
    it 'allows group_default: true once within combination of group type and filter_purposes' do
      filter_house = create :filter, name: 'house', group: 'property_type', purpose_list: %w(purchase)
      filter_appt  = create :filter, name: 'appartment', group: 'property_type', purpose_list: %w(other)

      expect(filter_house.update(group_default: true)).to be true
      expect(filter_appt.update(group_default: true)).to be true
    end

    it 'does not allow group_default: true for two filters with same group and same filter_purpose' do
      filter_house = create :filter, name: 'house', group: 'property_type', purpose_list: %w(purchase)
      filter_appt  = create :filter, name: 'appartment', group: 'property_type', purpose_list: %w(purchase)

      expect(filter_house.update(group_default: true)).to be true
      expect(filter_appt.update(group_default: true)).to be false
      expect(filter_appt.errors.messages[:group].join(' ')).to include 'Tato skupina už má pro uvedené účely úvěru defaultní hodnotu'
    end
  end
end
