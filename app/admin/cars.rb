# typed: false
# frozen_string_literal: true

ActiveAdmin.register Car do
  decorate_with CarDecorator

  filter :title_cont
  filter :fuel, as: :select, collection: Car.fuels
  filter :transmission, as: :select, collection: Car.transmissions
  filter :features_id_in, as: :select, collection: Feature.order(:title).pluck(:title, :id)

  index do
    id_column
    column :title
    column :car_status do |resource|
      status_tag resource.car_status if resource.car_status
    end
    column :vin
    column :odometer
    column :manufactured
    column :transmission
    column :power_kw
    column :fuel
    column :created_at
    column :updated_at
  end

  show do
    panel title do
      attributes_table_for resource do
        row :manufactured
        row :odometer
        row :transmission
        row :power_kw
        row :fuel
        row :vin
        row :created_at
        row :updated_at
      end
    end

    panel 'Vlastnosti' do
      table_for resource.features do
        column :title
      end
    end
  end
end
