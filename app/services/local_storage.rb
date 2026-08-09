class LocalStorage
  def self.store(id, data)
    storage_path = Rails.root.join("local-storage")

    unless Dir.exist?(storage_path)
      Dir.mkdir(storage_path)#in case the local-storage directory does not exist. 
    end

    file_path = storage_path.join("#{id}.bin")#name of the file 
    File.binwrite(file_path, data)
end

def self.retrieve(id)
    storage_path = Rails.root.join("local-storage")
    file_path = storage_path.join("#{id}.bin")
  
  return nil unless file_path.exist?

  undecoded_data=File.binread(file_path)
Base64.strict_encode64(undecoded_data)

end




end
