class AddNotifiedToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :notified, :boolean, null: false, default: false
  end
end
