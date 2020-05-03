# typed: false
# frozen_string_literal: true

require 'rails_helper'

feature 'Existing base variant', js: true do
  before do
    log_in(find_or_create(:user, :admin))
  end

  let(:product)      { create :product, default_unlisted_discount: 0.2 }
  let(:rates)        { [[1, 2.3]] }
  let(:base_variant) { create :variant, product: product, rates: rates }

  context 'Rate' do
    scenario 'Add' do
      visit product_variant_path(product, base_variant)

      click_action_button('Sazby', :add)
      wait_for_ajax

      fill_in 'Fixace', with: '10'
      fill_in 'Sazba', with: 3.3
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content '10 years 3,30% NE NE upravit | smazat'
    end

    scenario 'Add' do
      visit product_variant_path(product, base_variant)

      expect(base_variant.product_rates.count).to eq 1

      within('#rates') { click_on 'upravit' }
      wait_for_ajax

      fill_in 'Sazba', with: '10'
      click_on 'Uložit'
      wait_for_ajax

      expect(page).to have_content '1 year 10,00% NE NE upravit | smazat'
    end
  end

  context 'Condition' do
    let(:condition) { create :product_condition, :insurance, variant: base_variant }

    scenario 'Add', js: true do
      visit product_variant_path(product, base_variant)

      click_action_button('Podmínky', :add)
      wait_for_ajax

      select 'zkolaudovaná nemovitost', from: 'Podmínka'
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content 'zkolaudovaná nemovitost NE NE smazat'
    end
  end
end
