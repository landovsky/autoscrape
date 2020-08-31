class AddCompanyToFeatures < ActiveRecord::Migration[5.2]
  def change
    add_column :features, :company, :integer

    reversible do |dir|
      dir.up do
        Feature.update_all(company: 1)
      end
    end
  end
end
