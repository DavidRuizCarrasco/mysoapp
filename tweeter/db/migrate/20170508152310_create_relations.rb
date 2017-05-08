class CreateRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :relations do |t|
      t.references :user1, foreign_key: true
      t.references :user2, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
