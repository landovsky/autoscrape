class CreateCarFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :car_features do |t|
      t.references :feature, foreign_key: true
      t.references :car, foreign_key: true

      t.timestamps
    end
  end
end
