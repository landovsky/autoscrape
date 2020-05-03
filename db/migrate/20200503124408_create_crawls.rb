class CreateCrawls < ActiveRecord::Migration[5.2]
  def change
    create_table :crawls do |t|
      t.references :car, foreign_key: true
      t.text :body
      t.timestamp :parsed_at

      t.timestamps
    end
  end
end
