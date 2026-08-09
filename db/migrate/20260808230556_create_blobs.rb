class CreateBlobs < ActiveRecord::Migration[8.1]
  def change
    create_table :blobs, id: false do |t|
      t.string :id, null: false
      t.integer :size, null: false
      t.string :storage_backend, null: false

      t.timestamps
    end

    add_index :blobs, :id, unique: true
  end
end