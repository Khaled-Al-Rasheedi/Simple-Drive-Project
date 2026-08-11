require 'net/ftp'
require 'stringio'

class FtpStorage
  def self.store(blob_id, raw_binary_data)
    port = ENV.fetch('FTP_PORT', 21).to_i
    host = ENV['FTP_HOST'] 
    username = ENV['FTP_USERNAME']
    password = ENV['FTP_PASSWORD']

    Net::FTP.open(host, port: port, username: username, password: password) do |ftp|
      # Ensure the remote directory exists, ignore error if it already does
      begin
        ftp.mkdir("ftp-storage")
      rescue Net::FTPPermError
        # Directory already exists
      end

      # Move into the dedicated directory
      ftp.chdir("ftp-storage")

      # Convert the raw binary string into an IO stream
      file_stream = StringIO.new(raw_binary_data)
      
      # Push the stream to the server inside the folder
      ftp.storbinary("STOR #{blob_id}", file_stream, Net::FTP::DEFAULT_BLOCKSIZE)
    end
    
    true
  rescue StandardError => e
    Rails.logger.error("FTP Upload failed: #{e.message}")
    false
  end

  def self.retrieve(blob_id)
    binary_data = nil
    
    host = ENV['FTP_HOST'] 
    username = ENV['FTP_USERNAME']
    password = ENV['FTP_PASSWORD']
    port = ENV.fetch('FTP_PORT', 21).to_i

    Net::FTP.open(host, port: port, username: username, password: password) do |ftp|
      # Change into the dedicated directory before fetching
      ftp.chdir("ftp-storage") rescue nil
      
      binary_data = ftp.getbinaryfile(blob_id, nil)
    end

    Base64.strict_encode64(binary_data)
  end
end