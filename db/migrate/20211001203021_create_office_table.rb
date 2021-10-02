class CreateOfficeTable < ActiveRecord::Migration[6.1]
  def change
    create_table :officers do |t|
      t.integer :officer_id
      t.string :name
      t.string :email
      t.float :amountOwed

      t.timestamps
    end
  end
end
