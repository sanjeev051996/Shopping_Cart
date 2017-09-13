class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
    	t.string :name
    	t.text :description
    	t.float :price
    	t.integer :stock
    	t.string :country
    	t.string :state
    	t.string :zip_code
    	t.float :tax_rate
    	t.boolean :cod
    	t.float :shipping_charge_rate

    	t.timestamps
    end
  end
end
