require "test_helper"

class StorageControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Generate a valid token in the test database so check_token passes
    ApiToken.create!(token: "valid_test_token")
    @headers = { "Authorization" => "Bearer valid_test_token" }
    
    @valid_base64 = Base64.strict_encode64("raw_binary_data")
  end

  test "returns 422 Unprocessable Entity for invalid base64 data" do
    post "/store", params: { id: "test1", data: "Invalid_!@#_Base64" }, headers: @headers
    
    assert_response :unprocessable_entity
    assert_equal "Invalid Base64 data", JSON.parse(response.body)["error"] 
  end

  test "returns 409 Conflict if blob ID already exists" do
    Blob.create!(id: "duplicate_id", size: 10, storage_backend: "local")
    
    post "/store", params: { id: "duplicate_id", data: @valid_base64 }, headers: @headers
    
    assert_response :conflict
    assert_equal "Blob with ID duplicate_id already exists", JSON.parse(response.body)["errors"] 
  end

  test "destroys blob metadata and returns 500 if storage router fails" do
    # Force the router to fail by specifying an invalid backend
    ENV["STORAGE_BACKEND"] = "invalid_backend"

    # assert_no_difference ensures the total Blob count is identical before and after the request
    assert_no_difference('Blob.count') do
      post "/store", params: { id: "rollback_test", data: @valid_base64 }, headers: @headers
    end

    assert_response :internal_server_error
    assert_equal "Storage backend failed to save the file.", JSON.parse(response.body)["errors"] 
  end
end