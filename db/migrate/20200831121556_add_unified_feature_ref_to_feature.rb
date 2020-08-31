class AddUnifiedFeatureRefToFeature < ActiveRecord::Migration[5.2]
  def change
    add_reference :features, :unified_feature, foreign_key: true
  end
end
