require "test_helper"

class StorageRouterTest < ActiveSupport::TestCase
  test "defaults to local storage if ENV is missing" do
    ENV.delete("STORAGE_BACKEND")
    
    # Since LocalStorage returns true on success, the router should pass it up
    result = StorageRouter.storage("test_id", "data")
    assert_equal true, result
  end

  test "returns false to trigger rollback if the backend ENV is misspelled" do
    # Step 1: Determine the current active storage backend[cite: 6]
    ENV["STORAGE_BACKEND"] = "s4_typo" 
    
    result = StorageRouter.storage("test_id", "data")
    
    # Step 3: Return true/false so the storage_controller knows to keep or destroy the blob[cite: 6]
    assert_equal false, result 
  end

  test "returns nil when retrieving from an invalid backend" do
    # Force a bad backend string
    ENV["STORAGE_BACKEND"] = "fake_backend"
    Blob.create!(id: "bad_retrieval_id", size: 10, storage_backend: "fake_backend")
    
    result = StorageRouter.retrieve("bad_retrieval_id")
    
    # Verifies the else condition in the retrieve method[cite: 6]
    assert_nil result 
  end
end