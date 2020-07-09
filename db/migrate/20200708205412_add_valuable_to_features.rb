class AddValuableToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :valuable, :boolean, default: false
  end
end
