class AddFormatToCrawls < ActiveRecord::Migration[5.2]
  def change
    add_column :crawls, :format, :integer, default: 1
  end
end
