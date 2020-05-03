# typed: false
# frozen_string_literal: true

require 'rails_helper'

feature 'Filters' do
  before do
    log_in(find_or_create(:user, :admin))
  end

  scenario 'Create new filter' do
    visit filters_path

    within('.title_bar') { click_on 'Vytvořit' }
    fill_in 'Název filtru', with: 'Filter test'
    select 'typ nemovitosti', from: 'Skupina'
    check 'budoucí koupě'
    check 'bez účelu'
    click_on 'Create Filtr'

    expect(page).to have_content 'Filter was successfully created'
    expect(page).to have_content 'Filter test'
    expect(page).to have_content 'budoucí koupě'
    expect(page).to have_content 'bez účelu'
  end

  scenario 'Update existing filter' do
    filter = create :filter, name: 'Existing filter', purpose_list: %w(other future_purchase)
    expect(filter.purposes.count).to eq 2

    visit filters_path

    click_on filter.id.to_s
    fill_in 'Název filtru', with: 'Something else'
    uncheck 'budoucí koupě'
    click_on 'Update Filtr'

    expect(page).to have_content 'Filter was successfully updated'
    expect(page).to have_content 'Something else'
    expect(filter.purposes.count).to eq 1
  end
end
