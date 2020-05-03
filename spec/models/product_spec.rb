# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe Product do
  let(:product) { create :product }

  describe '.variant_created' do
    it "it registers product's base_variant if none exists" do
      expect(product.base_variant_id).to be nil

      # variant_created is called by Variant after_create callback
      variant = create :variant, product: product

      expect(product.reload.base_variant_id).to eq variant.id
    end

    it "it does not change product's base_variant if one already exists" do
      base_variant = create :variant, ltv_max: 80, product: product
      expect(product.base_variant_id).to be base_variant.id

      _another_variant = create :variant, ltv_max: 90, product: product

      expect(product.reload.base_variant_id).to eq base_variant.id
    end
  end

  describe '.destroy_variant' do
    let(:base_variant)    { create :variant, ltv_max: 80, product: product }
    let(:another_variant) { create :variant, ltv_max: 90, product: product }

    it 'prevents destruction of shared variant' do
      base_variant
      another_variant

      product.destroy_variant base_variant

      expect(base_variant.reload.persisted?).to be true
      expect(base_variant.errors.messages[:base].join(' ')).to include 'cannot delete shared variant'
    end

    it 'deletes descendant variant' do
      product.destroy_variant another_variant

      expect { another_variant.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'deletes shared variant when no other variants depend on it' do
      product.destroy_variant another_variant

      product.destroy_variant base_variant

      expect { base_variant.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'unregisters base variant after its deletion' do
      product.destroy_variant base_variant

      expect(product.base_variant_id).to be nil
    end
  end
end
