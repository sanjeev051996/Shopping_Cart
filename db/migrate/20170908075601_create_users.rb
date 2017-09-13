class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :admin, dafault: false
      t.string :contact
      t.string :country
      t.string :state
      t.text :address
      t.date :dob
      t.timestamps
    end
  end
end
