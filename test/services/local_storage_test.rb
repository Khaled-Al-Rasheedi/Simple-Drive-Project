require "test_helper"

class LocalStorageTest < ActiveSupport::TestCase
  setup do
    @id = "local_test_blob"
    @data = "raw_binary_test_string"
    @file_path = Rails.root.join("local-storage", "#{@id}.bin") 
    #To setup the test variables.
  end

  teardown do #This method runs after each test
    
    # Clean up the storage after the test runs so we don't leave test files behind
    File.delete(@file_path) if File.exist?(@file_path)
  end

  test "successfully stores data and returns true" do
    result = LocalStorage.store(@id, @data)
    
    #
    assert_equal true, result 
    assert File.exist?(@file_path)
  end

  test "successfully retrieves and base64 encodes the data" do
    # Write the file first
    LocalStorage.store(@id, @data)
    
    retrieved_data = LocalStorage.retrieve(@id)
    
    # Verifies the retrieval base64 encodes the undecoded_data[cite: 4]
    assert_equal Base64.strict_encode64(@data), retrieved_data 
  end

  test "returns nil if the file does not exist during retrieval" do
    # Verifies: return nil unless file_path.exist?[cite: 4]
    assert_nil LocalStorage.retrieve("non_existent_id") 
  end
end