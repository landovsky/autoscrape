# typed: false
# frozen_string_literal: true

require 'rails_helper'

feature 'Variants' do
  before do
    log_in(find_or_create(:user, :admin))
  end

  let(:product) { create :product, default_unlisted_discount: 0.2 }

  scenario 'Create new product variant' do
    visit product_path(product)

    click_action_button('LTV varianty', :add)

    # Unlisted discount prefilled from parent product's bank
    expect(find('input#variant_unlisted_discount').value).to eq '0.2'
    fill_in 'LTV max', with: 60
    fill_in 'Výše úvěru od', with: 1000
    fill_in 'Výše úvěru do', with: 10_000
    fill_in 'Splatnost od', with: 1
    fill_in 'Splatnost do', with: 10
    fill_in 'Neveřejná sleva ', with: 0.3
    click_on 'Create Variant'

    expect(page).to have_content 'Výše úvěru 1 000 - 10 000 CZK'
    expect(page).to have_content 'Splatnost 1 - 10 years'
    expect(page).to have_content 'Neveřejná Sleva 0,30%'
    expect(page).to have_content 'Základní varianta'
  end

  scenario 'Delete product variant' do
    variant = create :variant, product: product

    visit product_variant_path(product, variant)

    within('.title_bar') { click_on 'Smazat' }

    expect { variant.reload }.to raise_error ActiveRecord::RecordNotFound
  end
end
