# typed: false
# frozen_string_literal: true

require 'rails_helper'

feature 'Existing descendant variant', js: true do
  before do
    log_in(find_or_create(:user, :admin))
  end

  let(:product)            { create :product }
  let!(:base_variant)      { create :variant, ltv_max: 80, product: product }
  let(:descendant_variant) { create :variant, ltv_max: 60, product: product }

  context 'Inherits from base variant' do
    scenario 'Inherits rates' do
      create :product_rate, variant: base_variant, fixation: 1, rate: 2.3

      visit product_variant_path(product, descendant_variant)

      within('#rates') do
        expect(page).to have_content '1 year 2,30% ANO NE přetížit | skrýt'
      end
    end

    scenario 'Inherits conditions' do
      create :product_condition, :insurance, variant: base_variant

      visit product_variant_path(product, descendant_variant)

      within('#conditions') { expect(page).to have_content 'pojištění schopnosti splácet ANO NE skrýt' }
    end
  end

  context 'Inherited rate' do
    let!(:inherited_rate) { create :product_rate, variant: base_variant, fixation: 1, rate: 2 }

    scenario 'Override' do
      visit product_variant_path(product, descendant_variant)

      within('#rates') do
        click_on 'přetížit'
      end
      wait_for_ajax
      fill_in 'Sazba', with: 5.3
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content '1 year 5,30% NE NE upravit | smazat'
    end

    scenario 'Hide' do
      visit product_variant_path(product, descendant_variant)

      within('#rates') { click_on 'skrýt' }

      expect(page).to have_content '1 year 2,00% NE ANO odkrýt'
    end

    scenario 'Unhide' do
      create :product_rate, variant: descendant_variant, fixation: 1, rate: 2, hidden: true

      visit product_variant_path(product, descendant_variant)

      expect(page).to have_content '1 year 2,00% NE ANO odkrýt'

      within('#rates') { click_on 'odkrýt' }

      expect(page).to have_content '1 year 2,00% ANO NE přetížit | skrýt'
    end
  end

  context 'Inherited condition' do
    let!(:inherited_condition) { create :product_condition, :insurance, variant: base_variant }

    scenario 'Hide' do
      visit product_variant_path(product, descendant_variant)

      expect(page).to have_content 'pojištění schopnosti splácet ANO NE skrýt'

      within('table#conditions') { click_on 'skrýt' }

      expect(page).to have_content 'pojištění schopnosti splácet NE ANO odkrýt'
    end

    scenario 'Unhide' do
      create :product_condition, :insurance, variant: descendant_variant, hidden: true

      visit product_variant_path(product, descendant_variant)

      expect(page).to have_content 'pojištění schopnosti splácet NE ANO odkrýt'

      within('table#conditions') do
        click_on 'odkrýt'
      end

      expect(page).to have_content 'pojištění schopnosti splácet ANO NE skrýt'
    end
  end
end
