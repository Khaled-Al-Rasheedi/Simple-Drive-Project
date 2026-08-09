class StorageRouter

    def self.route_storage(blob_id,blob_data)
#Step 1: Determine the current active storage backend
#Step 2: Call upon the methods of each storage backend
#Step 3: Return the storage backend used for tracking purposes
    storage_backend = ENV["STORAGE_BACKEND"] || "local" # Default to local storage if not specified
    case storage_backend
    when "local"
        LocalStorage.store(blob_id, blob_data)
        return storage_backend
    when "s3"
        S3Storage.store(blob_id, blob_data)
        return storage_backend
    when "database"
        DatabaseStorage.store(blob_id, blob_data)
        return storage_backend
    end
end


#I need to add a column to the blob table so that I track the file system of it
    def self.route_retrieval(blob)
    end



end
