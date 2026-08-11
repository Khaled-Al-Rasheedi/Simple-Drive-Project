class StorageController < ApplicationController
  require "base64"
  before_action :check_token, only: [:store, :retrieve]

  def store
    # Step 1: Get the ID and data from the request parameters
    # Step 2: Decode the Base64 and check if the ID is already reserved
    # Step 3: Create a new Blob record with the ID, size, and storage backend used
    # Step 4: Call the StorageRouter to store the blob data in the appropriate backend
    # Step 5: If the blob fails to save to the backend, destroy the metadata record
    
    req_id = request.params[:id]

    begin # Rescue block to prevent invalid Base64 data from crashing the system
      req_data = Base64.strict_decode64(params[:data])
    rescue ArgumentError
      render json: { error: "Invalid Base64 data" }, status: :unprocessable_entity
      return
    end 

    if Blob.exists?(id: req_id) # Check if the ID is reserved
      render json: { errors: "Blob with ID #{req_id} already exists" }, status: :conflict
      return
    end 

    blob = Blob.create(
      id: req_id,
      size: req_data.bytesize,
      storage_backend: ENV["STORAGE_BACKEND"]
    )

    if blob.persisted? # Check if creation of blob metadata was successful
      storage_success = false # Default to false in case of a fatal crash
      
      begin # Catch any failed network/storage attempts
        storage_success = StorageRouter.storage(req_id, req_data)
      rescue => e
        # Catch any escaped system crashes so the controller doesn't die
        Rails.logger.error("Backend fatal error: #{e.message}")
      end

      if storage_success
        render json: blob, status: :created 
      else
        blob.destroy
        render json: { errors: "Storage backend failed to save the file." }, status: :internal_server_error
      end 

    else
      # Safely extract database validation errors if blob creation fails
      render json: { errors: blob.errors.full_messages.join(", ") || "Metadata storage failed" }, status: :internal_server_error
    end 
  end

  def retrieve
    req_id = request.params[:id]
    blob = Blob.find_by(id: req_id)
    
    if blob
      local_data = StorageRouter.retrieve(req_id)
      render json: { blob: blob, data: local_data }, status: :ok
    else
      render json: { errors: "Blob with ID #{req_id} not found" }, status: :not_found
    end
  end
end