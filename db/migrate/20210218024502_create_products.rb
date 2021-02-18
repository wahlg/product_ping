class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.text :url, null: false

      t.timestamps
    end
  end
end
