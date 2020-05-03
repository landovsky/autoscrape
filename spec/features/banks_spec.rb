# typed: false
# frozen_string_literal: true

require 'rails_helper'

feature 'Banks' do
  before do
    log_in(find_or_create(:user, :admin))
  end

  scenario 'Create new bank', skip: 'Mandatory Bank.code is not in the UI, therefore the test cannot pass' do
    visit banks_path

    within('.title_bar') { click_on 'Vytvořit' }
    fill_in 'Název banky', with: 'Nová banka'
    fill_in 'Defaultní sleva', with: 0.3
    fill_in 'Notifikace objednávek na', with: 'test.email29849384@testemail.com'
    click_on 'Create Bank'

    expect(page).to have_content 'Nová banka'
    expect(page).to have_content '0,30%'
  end
end
