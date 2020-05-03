# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe DenormalizedProductService::Builder do
  let(:product) { create :product }

  context 'When variant is discounted' do
    it 'creates record for each combination of variant, fixation and rate discount' do
      variant = create :variant, product: product, unlisted_discount: 0.1, rates: [[1, 3.0], [5, 4.0]]

      DenormalizedProduct.destroy_all

      expect { DenormalizedProductService::Builder.from_variant(variant) }.to(change do
        DenormalizedProduct.count
      end.by(4))
    end

    it 'discounts rates' do
      create :variant, product: product, unlisted_discount: 0.1, rates: [[1, 3.0]]

      discounted_products = DenormalizedProduct.where(unlisted: true)

      expect(discounted_products.count).to eq 1
      expect(discounted_products.first.rate).to eq 2.9
    end
  end

  context 'When variant is not discounted' do
    it 'creates record for each combination of variant and fixation' do
      variant = create :variant, product: product, rates: [[1, 3.0], [5, 4.0]]

      DenormalizedProduct.destroy_all

      expect { DenormalizedProductService::Builder.from_variant(variant) }.to(change do
        DenormalizedProduct.count
      end.by(2))
    end
  end

  it "calculates variant's ltv_min" do
    variant_one = create :variant, product: product, ltv_max: 60, rates: [[1, 3.0]]
    variant_two = create :variant, product: product, ltv_max: 80, rates: [[1, 3.0]]

    expect(DenormalizedProduct.find_by(variant_id: variant_one.id).ltv_min).to eq 0
    expect(DenormalizedProduct.find_by(variant_id: variant_one.id).ltv_max).to eq 60
    expect(DenormalizedProduct.find_by(variant_id: variant_two.id).ltv_min).to eq 60
    expect(DenormalizedProduct.find_by(variant_id: variant_two.id).ltv_max).to eq 80
  end
end
