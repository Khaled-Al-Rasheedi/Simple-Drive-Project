class StorageController < ApplicationController
  before_action :check_token, only: [:store, :retrieve]

  def store
    req_id = request.params[:id]
    req_data = request.params[:data]

    if Blob.exists?(id: req_id)
      render json: { errors: "Blob with ID #{req_id} already exists" }, status: :conflict
    else
      blob = Blob.create(id: req_id, size: req_data.length, storage_backend: "example")

      if blob.persisted?
        render json: blob, status: :created
      else
        render json: { errors: blob.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def retrieve
    req_id = params[:id]
    blob = Blob.find_by(id: req_id)

    if blob
      render json: blob, status: :ok
    else
      render json: { errors: "Blob with ID #{req_id} not found" }, status: :not_found
    end
  end
end