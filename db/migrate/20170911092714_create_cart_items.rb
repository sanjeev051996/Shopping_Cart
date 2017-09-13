class CreateCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.integer :quantity
      t.references :cart, foreign_key: true
      #t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.float :price
      t.float :tax_rate
      t.timestamps
    end
  end
end
