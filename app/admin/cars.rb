# typed: false
# frozen_string_literal: true

ActiveAdmin.register Car do
  decorate_with CarDecorator

  filter :title_cont
  filter :fuel, as: :select, collection: Car.fuels
  filter :transmission, as: :select, collection: Car.transmissions
  filter :features_id_in, as: :select, collection: Feature.order(:title).pluck(:title, :id)
  filter :url_cont

  scope :available, default: true
  scope :sold
  scope :deposit
  scope :price_changed
  scope :all

  controller do
    def scoped_collection
      super.with_price.with_status.includes(:car_price, :car_status, :car_prices, :car_statuses)
    end
  end

  collection_action :crawl_all, method: :get do
    CrawlerService.call

    redirect_to cars_path, notice: 'Updated'
  end

  member_action :crawl_some, method: :get do
    CrawlerService.call! Car.find(params[:id])

    redirect_to car_path(params[:id]), notice: 'Updated'
  end

  index do
    a 'Aktualizovat', href: crawl_all_cars_path, class: 'button', style: 'margin-bottom: 12px'

    id_column
    column :title, &:title_link
    column :car_status, sortable: 'car_statuses.sales_status' do |resource|
      status_tag resource.car_status if resource.car_status
    end
    column :price, sortable: 'car_prices.price'
    column :rating, sortable: 'cars.rating'
    column :discount
    column :odometer
    column :manufactured
    column :transmission
    column :power_kw
    column :created_at
    column :updated_at
  end

  show do
    div style: 'width: 550px' do
      panel resource.title_link do
        h3 resource.price
        a 'Aktualizovat', href: crawl_some_car_path(resource), class: 'button', style: 'margin-bottom: 12px'
        attributes_table_for resource do
          row :manufactured
          row :odometer
          row :transmission
          row :power_kw
          row :fuel
          row :vin
          row :color, style: "background: ##{resource.color_hex}"
          row :created_at
          row :updated_at
        end
      end

      panel 'Prodej' do
        table_for resource.car_statuses do
          column :sales_status
          column :created_at
        end
      end

      panel 'Vlastnosti' do
        table_for resource.features do
          column :title
        end
      end
    end
  end
end
