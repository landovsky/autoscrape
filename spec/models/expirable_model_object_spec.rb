# typed: false
# frozen_string_literal: true

require 'rails_helper'

describe 'Model object with Expirable mixin' do
  context 'when validity_parent is set' do
    it 'inherits valid_from and valid_to from parent' do
      parent_product = create :product, valid_from: Time.zone.local(2019, 1, 1),
                                        valid_to: Time.zone.local(2019, 1, 31)
      variant = create :variant, product: parent_product

      expect(variant.valid_from).to eq Time.zone.local(2019, 1, 1)
      expect(variant.valid_to).to eq Time.zone.local(2019, 1, 31)
    end
  end

  context "when validity_children are set and parent's validity is updated" do
    let(:old_valid_from) { Time.zone.local(2019, 1, 1) }
    let(:old_valid_to)   { Time.zone.local(2019, 1, 31) }
    let(:new_valid_from) { Time.zone.local(2019, 1, 5) }
    let(:new_valid_to)   { Time.zone.local(2019, 1, 20) }
    let(:product)        { create :product, :with_fees, valid_from: old_valid_from, valid_to: old_valid_to }
    let(:product_fees)   { product.product_fees }
    let(:variant)        { create :variant, :with_rates, product: product }
    let!(:product_rates) { variant.product_rates }

    context "when children's validity would not be included in new parent's validity range" do
      it 'cascades new validity to children' do
        children = [product_fees, variant, product_rates].flatten

        # making sure that all children inherited validity from product
        children.each do |child|
          expect(child.valid_from).to eq old_valid_from
          expect(child.valid_to).to   eq old_valid_to
        end

        product.reload.update valid_from: new_valid_from, valid_to: new_valid_to

        expect(variant.reload.valid_from).to eq new_valid_from
        expect(variant.reload.valid_to).to   eq new_valid_to

        expect(product_fees.reload.first.valid_from).to eq new_valid_from
        expect(product_fees.reload.first.valid_to).to   eq new_valid_to

        expect(product_rates.reload.first.valid_from).to eq new_valid_from
        expect(product_rates.reload.first.valid_to).to   eq new_valid_to
      end
    end

    context "when children's validity would be included in new parent's validity range" do
      let(:included_valid_from) { Time.zone.local(2019, 1, 8) }
      let(:included_valid_to)   { Time.zone.local(2019, 1, 18) }

      it 'does not cascade new validty to children' do
        product_rates.each { |r| r.update(valid_from: included_valid_from, valid_to: included_valid_to) }

        product.reload.update valid_from: new_valid_from, valid_to: new_valid_to

        product_rates.reload
        expect(product_rates.all? { |i| i.valid_from == included_valid_from }).to be true
        expect(product_rates.all? { |i| i.valid_to   == included_valid_to }).to   be true
      end
    end

    context "shifting parent's validity beyond validity of children" do
      let(:far_right_valid_from) { Time.zone.local(2010, 1, 1) }
      let(:far_right_valid_to)   { Time.zone.local(2020, 1, 1) }

      it "sets children's validity to parent's validity_from" do
        product.reload.update valid_from: far_right_valid_from, valid_to: far_right_valid_from

        expect(variant.reload.valid_from).to eq far_right_valid_from
        expect(variant.reload.valid_to).to   eq far_right_valid_from

        expect(product_fees.reload.first.valid_from).to eq far_right_valid_from
        expect(product_fees.reload.first.valid_to).to   eq far_right_valid_from

        expect(product_rates.reload.first.valid_from).to eq far_right_valid_from
        expect(product_rates.reload.first.valid_to).to   eq far_right_valid_from
      end

      it "sets children's validity to parent's validity_from when parent's valid_from is > children's valid_from and valid_to" do
        product.reload.update valid_from: far_right_valid_to, valid_to: far_right_valid_to

        expect(variant.reload.valid_from).to eq far_right_valid_to
        expect(variant.reload.valid_to).to   eq far_right_valid_to

        expect(product_fees.reload.first.valid_from).to eq far_right_valid_to
        expect(product_fees.reload.first.valid_to).to   eq far_right_valid_to

        expect(product_rates.reload.first.valid_from).to eq far_right_valid_to
        expect(product_rates.reload.first.valid_to).to   eq far_right_valid_to
      end
    end
  end
end
