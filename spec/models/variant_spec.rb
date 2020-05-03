# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe Variant do
  describe 'create' do
    it 'fires report_new_variant_to_parent_product callback' do
      expect_any_instance_of(Variant).to receive(:report_new_variant_to_parent_product)

      create :variant
    end
  end

  describe '.destroy' do
    let(:product) { create :product }
    let!(:variant) { create :variant, product: product }

    it 'forwards regular destroy to product' do
      expect(product).to receive(:destroy_variant).with(variant)

      variant.destroy
    end

    it 'executes deletion when destroy is confirmed' do
      # Prevent foreign_key violation
      product.update(base_variant_id: nil)

      variant.destroy(confirmed: true)

      expect { variant.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
