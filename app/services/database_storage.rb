class DatabaseStorage


  def self.store(id, data)
    BlobStorage.create!(
      blob_id: id,
      data: data
    )

    #If above is true, return true to storage_router, the rest is skipped
    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    # 2. Catch database crashes gracefully and return false to trigger rollback
    Rails.logger.error("Database Storage failed: #{e.message}")
    false
  end



  

  def self.retrieve(id)
    record = BlobStorage.find_by(blob_id: id)    
    Base64.strict_encode64(record.data)
  end
end