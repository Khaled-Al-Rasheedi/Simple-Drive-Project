require "test_helper"

class DatabaseStorageTest < ActiveSupport::TestCase
  setup do
    @id = "database_test_blob"
    @data = "raw_binary_test_string"
    Blob.create!(id: @id, size: @data.bytesize, storage_backend: "database")
end

  test "successfully stores data in the database and returns true" do
    result = DatabaseStorage.store(@id, @data)
    
    assert_equal true, result
    assert BlobStorage.exists?(blob_id: @id)
  end

  test "returns false and catches exception if database insertion fails" do
    # Force a failure by storing the exact same ID twice to trigger an error
    DatabaseStorage.store(@id, @data)
    
    # The second attempt should hit the rescue block
    result = DatabaseStorage.store(@id, @data)
    
    assert_equal false, result
  end

  test "successfully retrieves and base64 encodes the data" do
    DatabaseStorage.store(@id, @data)
    
    retrieved_data = DatabaseStorage.retrieve(@id)
    
    assert_equal Base64.strict_encode64(@data), retrieved_data
  end
end