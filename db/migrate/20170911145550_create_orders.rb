class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :status, default: "unpaid"
      t.string :transaction_id
      t.text :address
      t.string :country
      t.string :state
      t.string :zip_code
      t.float :shipping_cost
      t.float :import_duty
      t.float :tax
      t.date :shipped_on
      t.date :delivered_on
      t.date :payment_date
      t.string :payment_mode
      t.string :card 
      t.string :cvv
      t.date :card_expiry_date
      t.float :amount
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
