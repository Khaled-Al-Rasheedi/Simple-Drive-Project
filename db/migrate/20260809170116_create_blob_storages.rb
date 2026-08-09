class CreateBlobStorages < ActiveRecord::Migration[8.1]
  def change
    #Original design was to make the foreign key a primary key at the same time 
    #However this idea was scrapped for now because it was not compatible with Rails' native primary key handling
    create_table :blob_storages do |t|
      t.string :blob_id, null: false
      t.binary :data, null: false

      t.timestamps
    end

    # Explicitly link blob_id to the string 'id' column in the blobs table
    add_foreign_key :blob_storages, :blobs, column: :blob_id, primary_key: :id
    
    # Ensure a one-to-one relationship at the database level
    add_index :blob_storages, :blob_id, unique: true
  end
end