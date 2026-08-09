class LocalStorage
  def self.store(id, data)
    storage_path = Rails.root.join("local-storage")

    unless Dir.exist?(storage_path)
      Dir.mkdir(storage_path)#in case the local-storage directory does not exist. 
    end

    file_path = storage_path.join(id)#name of the file 
    File.binwrite(file_path, data)
end
end
