# typed: false
# frozen_string_literal: true

require 'rails_helper'

# All tests depend on seeder data
describe Query::Filters do
  let!(:product) { create :product_complete }
  let(:query) { Query::Filters }

  it 'returns all filters when no conditions are specified' do
    expect(query.call.count).to eq 4
  end

  it 'filters by filter group' do
    q = query.call(group_names: [:property_type])
    expect(q.count).to eq 1
    expect(q.first.name).to eq 'chci družstevní byt'
  end

  it 'filters by purpose' do
    q = query.call(purpose_codes: [:purchase])
    expect(q.count).to eq 3
    expect(q.map(&:name)).to include 'chci družstevní byt', 'jsem OSVČ', 'mimořádná splátka zdarma'
  end
end
