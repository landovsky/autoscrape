class CreateUnifiedFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :unified_features do |t|
      t.string :title
      t.boolean :valuable

      t.timestamps
    end
  end
end
