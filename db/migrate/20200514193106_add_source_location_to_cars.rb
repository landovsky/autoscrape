class AddSourceLocationToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :source, :integer
    add_column :cars, :location, :string
  end
end
