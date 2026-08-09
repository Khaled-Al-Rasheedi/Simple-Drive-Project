class StorageController < ApplicationController
  require "base64"

  before_action :check_token, only: [:store, :retrieve]

  def store
    req_id = request.params[:id]
    begin
    req_data = Base64.strict_decode64(params[:data])
 rescue ArgumentError
  render json: { error: "Invalid Base64 data" }, status: :unprocessable_entity
return 
end
    if Blob.exists?(id: req_id)
      render json: { errors: "Blob with ID #{req_id} already exists" }, status: :conflict
    else
      blob = Blob.create(id: req_id, size: req_data.bytesize, storage_backend: "example")

      if blob.persisted?
        LocalStorage.store(req_id,req_data)
        render json: blob, status: :created
      else
        render json: { errors: blob.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def retrieve
  req_id = request.params[:id]
  blob = Blob.find_by(id: req_id)

    if blob
      render json: blob, status: :ok
    else
      render json: { errors: "Blob with ID #{req_id} not found" }, status: :not_found
    end


  end
end