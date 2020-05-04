class AddColorsToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :color, :string
    add_column :cars, :color_hex, :string
  end
end
