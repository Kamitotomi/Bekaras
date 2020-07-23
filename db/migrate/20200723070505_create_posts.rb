class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :body
      t.text :event
      t.integer :category
      t.integer :status
      t.integer :user_id

      t.timestamps
    end
  end
end
