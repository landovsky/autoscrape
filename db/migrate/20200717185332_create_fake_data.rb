class CreateFakeData < ActiveRecord::Migration[5.2]
  def change
    create_table :fake_data do |t|
      t.datetime :timestamp
      t.string :title
      t.float :temperature
      t.integer :pressure
      t.integer :dimensionx
      t.integer :dimensiony
      t.float :weight
    end
  end
end
