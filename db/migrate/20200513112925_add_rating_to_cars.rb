class AddRatingToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :rating, :integer
  end
end
