class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.string :text
      t.references :user, foreign_key: true
      t.integer :likes

      t.timestamps
    end
  end
end
