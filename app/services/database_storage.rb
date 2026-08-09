class DatabaseStorage
  def self.store(id, data)
    BlobStorage.create!(
      blob_id: id,
      data: data
    )
  end

  def self.retrieve(id)
    record = BlobStorage.find_by(blob_id: id)    
    Base64.strict_encode64(record.data)
  end
end