class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.string :email
      t.string :product
      t.integer :price
      t.integer :quantity
      t.integer :total

      t.timestamps
    end
  end
end
