require 'net/ftp'
require 'stringio'
class FtpStorage

  def self.store(blob_id, raw_binary_data)
    @port = ENV.fetch('FTP_PORT', 21).to_i
    @host = ENV['FTP_HOST'] # 
    @username = ENV['FTP_USERNAME']
    @password = ENV['FTP_PASSWORD']

    # Open the connection to the server
Net::FTP.open(@host, port: @port, username: @username, password: @password) do |ftp|      
      # Convert the raw binary string into an IO stream
      file_stream = StringIO.new(raw_binary_data)
      # storbinary pushes the stream to the server and saves it as the blob_id
      ftp.storbinary("STOR #{blob_id}", file_stream, Net::FTP::DEFAULT_BLOCKSIZE)
    end
    
    # if the above was successful, return true to storage_router, the rest is skipped
    true
  rescue Net::FTPError => e
    # Handle connection or upload failures
    Rails.logger.error("FTP Upload failed: #{e.message}")
    false
  end


  
  def self.retrieve(blob_id)
    binary_data = nil
    
    @host = ENV['FTP_HOST'] 
    @username = ENV['FTP_USERNAME']
    @password = ENV['FTP_PASSWORD']
    @port = ENV.fetch('FTP_PORT', 21).to_i

 Net::FTP.open(@host, port: @port, username: @username, password: @password) do |ftp|
 # getbinaryfile usually downloads to a local path, 
 # but passing nil allows us to read it directly into memory
 binary_data = ftp.getbinaryfile(blob_id, nil)
end

    binary_data
  end
end