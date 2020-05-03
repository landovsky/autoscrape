# typed: false
# frozen_string_literal: true

require 'rails_helper'

feature 'Products' do
  before do
    log_in(find_or_create(:user, :admin))
  end

  context 'New product' do
    let!(:bank) { create :bank, name: 'Nová Banka' }

    scenario 'Create product' do
      visit products_path

      within('.title_bar') { click_on 'Vytvořit' }
      select 'Nová Banka', from: 'Banka'
      select Product::METHOD_30_360, from: 'Výpočetní model'
      fill_in 'Název', with: 'Super produkt'
      check 'koupě nemovitosti'
      check 'refinancování'
      click_on 'Create Produkt'

      expect(page).to have_content 'Product was successfully created'

      expect(page).to have_content 'Banka Nová Banka'
      expect(page).to have_content 'koupě nemovitosti'
      expect(page).to have_content 'refinancování'
    end
  end

  context 'Existing product' do
    let!(:product) { create :product, name: 'Fajn produkt', purpose_list: ['bez účelu', 'budoucí koupě'] }

    scenario 'Update product' do
      visit products_path

      click_on 'Fajn produkt'
      click_on 'Upravit'

      fill_in 'Název', with: 'New product name'
      uncheck 'bez účelu'
      click_on 'Update Produkt'

      expect(page).to have_content 'New product name'
      expect(page).not_to have_content 'bez účelu'
    end

    scenario 'Add filters', js: true, skip: 'randomly failing test' do
      visit product_path(product)

      click_action_button('Filtry', :add)
      wait_for_ajax

      select 'jsem OSVČ', from: 'Filter'
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content 'jsem OSVČ smazat'
    end

    scenario 'Add fees', js: true do
      visit product_path(product)

      click_action_button('Poplatky', :add)
      wait_for_ajax

      select 'vedení účtu', from: 'Poplatek'
      check 'Povinná součást produktu'
      fill_in 'Částka', with: 300
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content 'vedení účtu 300 CZK jednorázově ANO upravit | smazat'
    end

    scenario 'Add documents', js: true do
      visit product_path(product)

      click_action_button('Dokumenty', :add)
      wait_for_ajax

      select 'doložení příjmů', from: 'Dokument'
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content 'doložení příjmů smazat'
    end

    scenario 'Add features', js: true do
      visit product_path(product)

      click_action_button('Vlastnosti', :add)
      wait_for_ajax

      select 'mimořádná splátka zdarma', from: 'Vlastnost'
      click_on 'Přidat'
      wait_for_ajax

      expect(page).to have_content 'mimořádná splátka zdarma'
    end
  end
end
