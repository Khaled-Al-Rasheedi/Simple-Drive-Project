class StorageController < ApplicationController
require "base64"
before_action :check_token, only: [:store, :retrieve]
  def store
#Step 1: Get the ID and data from the request parameters
#Step 2: Decode the Base64 and check if the id is already reserved
#Step 3: Call the StorageRouter to store the data
#Step 4: Create a new Blob record with the ID, size, and storage backend used
    
    req_id = request.params[:id] #Get the ID from the request parameters

    begin #Resuce block to prevent invali d Base64 data from crashing system
        req_data = Base64.strict_decode64(params[:data])
      rescue ArgumentError
        render json: { error: "Invalid Base64 data" }, status: :unprocessable_entity
        return
    end #End of rescue block

    if Blob.exists?(id: req_id) #Check if the ID is reserved
      render json: { errors: "Blob with ID #{req_id} already exists" }, status: :conflict
      return
    end #End of check for reserved ID

   blob = Blob.create(
     id: req_id,
     size: req_data.bytesize,
     storage_backend: ENV["STORAGE_BACKEND"]
    )
  result = StorageRouter.storage(req_id, req_data)#To store the the blob

    if blob.persisted? #Check if creation of blob was successful
     render json: blob, status: :created #Show blob for this current stage to the user
   else
    #TODO: I should create a delete method to get rid of the files if blobs couldn't be created
    render json: { errors: result.error || "Storage failed" }, status: :internal_server_error
    #The above is temp error incase saving has failed
  end #end of check if blob was created successfully

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

