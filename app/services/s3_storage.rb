  require "digest"
  require "openssl"
  require "net/http"
  require "uri"
  class S3Storage
    BUCKET = ENV["AWS_BUCKET_NAME"]
    REGION = ENV["AWS_REGION"]

    ACCESS_KEY = ENV["AWS_ACCESS_KEY_ID"]
    SECRET_KEY = ENV["AWS_SECRET_ACCESS_KEY"]



    def self.store(key, data)
      
      method = "PUT"
      path ="/#{key}"
      host= "#{BUCKET}.s3.#{REGION}.amazonaws.com"
      body = data
      payload_hash = Digest::SHA256.hexdigest(body)

      # Step 6: AWS timestamp
  amz_date = Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
  date = Time.now.utc.strftime("%Y%m%d")

  # Step 7: x-amz-date header
  x_amz_date = amz_date

  # Step 8: Canonical headers
  canonical_headers = [
    "host:#{host}",
    "x-amz-content-sha256:#{payload_hash}",
    "x-amz-date:#{x_amz_date}"
  ].join("\n") + "\n"

  # Step 9: Signed headers
  signed_headers = "host;x-amz-content-sha256;x-amz-date"

  # Step 10: Canonical request
  canonical_request = [
    method,
    path,
    "",
    canonical_headers,
    signed_headers,
    payload_hash
  ].join("\n")
  # Step 11: Hash the canonical request
  canonical_request_hash = Digest::SHA256.hexdigest(canonical_request)

  # Step 12: Credential scope
  credential_scope = "#{date}/#{REGION}/s3/aws4_request"

  # Step 13: String to sign
  string_to_sign = [
    "AWS4-HMAC-SHA256",
    amz_date,
    credential_scope,
    canonical_request_hash
  ].join("\n")

  # Step 14: Derive the signing key
  date_key = OpenSSL::HMAC.digest(
    "SHA256",
    "AWS4#{SECRET_KEY}",
    date
  )

  region_key = OpenSSL::HMAC.digest(
    "SHA256",
    date_key,
    REGION
  )

  service_key = OpenSSL::HMAC.digest(
    "SHA256",
    region_key,
    "s3"
  )

  signing_key = OpenSSL::HMAC.digest(
    "SHA256",
    service_key,
    "aws4_request"
  )

  # Step 15: Final signature
  signature = OpenSSL::HMAC.hexdigest(
    "SHA256",
    signing_key,
    string_to_sign
  )

  # Step 16: Authorization header
  authorization = "AWS4-HMAC-SHA256 " \
                "Credential=#{ACCESS_KEY}/#{credential_scope}, " \
                "SignedHeaders=#{signed_headers}, " \
                "Signature=#{signature}"

  # Step 17: Build the actual HTTP request

  uri = URI("https://#{host}#{path}")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Put.new(uri.request_uri)

  request["Host"] = host
  request["x-amz-date"] = amz_date
  request["x-amz-content-sha256"] = payload_hash
  request["Authorization"] = authorization

      request.body = body
      response = http.request(request)

    # ... (all your awesome AWS signing code stays exactly the same) ...
  
    request.body = body
    response = http.request(request)

    # 1. Check if the HTTP status code is exactly "200" (Success)
    if response.code == "200"
      true
    else
      # 2. If S3 rejects it, log S3's error message and return false
      Rails.logger.error("S3 Upload Failed: [HTTP #{response.code}] #{response.body}")
      false
    end
  rescue StandardError => e
    # 3. Catch pure network failures (like if the computer loses internet)
    Rails.logger.error("S3 Network Crash: #{e.message}")
    false
  end
    
    
    end





    def self.retrieve(blob_id)

    # Step 1: HTTP method
    method = "GET"

    # Step 2: URI / path
    path = "/#{blob_id}"

    # Step 3: Host
    host = "#{BUCKET}.s3.#{REGION}.amazonaws.com"

    # Step 4: AWS timestamp
    amz_date = Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
    date = Time.now.utc.strftime("%Y%m%d")

    # Step 5: Empty payload hash
    payload_hash = Digest::SHA256.hexdigest("")

    # Step 6: x-amz-date
    x_amz_date = amz_date

    # Step 7: Canonical headers
    canonical_headers = [
      "host:#{host}",
      "x-amz-content-sha256:#{payload_hash}",
      "x-amz-date:#{x_amz_date}"
    ].join("\n") + "\n"

    # Step 8: Signed headers
    signed_headers = "host;x-amz-content-sha256;x-amz-date"

    # Step 9: Canonical request
    canonical_request = [
      method,
      path,
      "",
      canonical_headers,
      signed_headers,
      payload_hash
    ].join("\n")

    # Step 10: Hash the canonical request
    canonical_request_hash =
      Digest::SHA256.hexdigest(canonical_request)

    # Step 11: Credential scope
    credential_scope =
      "#{date}/#{REGION}/s3/aws4_request"

    # Step 12: String to sign
    string_to_sign = [
      "AWS4-HMAC-SHA256",
      amz_date,
      credential_scope,
      canonical_request_hash
    ].join("\n")

    # Step 13: Derive the signing key
    date_key = OpenSSL::HMAC.digest(
      "SHA256",
      "AWS4#{SECRET_KEY}",
      date
    )

    region_key = OpenSSL::HMAC.digest(
      "SHA256",
      date_key,
      REGION
    )

    service_key = OpenSSL::HMAC.digest(
      "SHA256",
      region_key,
      "s3"
    )

    signing_key = OpenSSL::HMAC.digest(
      "SHA256",
      service_key,
      "aws4_request"
    )

    # Step 14: Final signature
    signature = OpenSSL::HMAC.hexdigest(
      "SHA256",
      signing_key,
      string_to_sign
    )

    # Step 15: Authorization header
    authorization = "AWS4-HMAC-SHA256 " +
                    "Credential=#{ACCESS_KEY}/#{credential_scope}, " +
                    "SignedHeaders=#{signed_headers}, " +
                    "Signature=#{signature}"

    # Step 16: Build the actual HTTP GET request
    uri = URI("https://#{host}#{path}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)

    request["Host"] = host
    request["x-amz-date"] = amz_date
    request["x-amz-content-sha256"] = payload_hash
    request["Authorization"] = authorization

    # Step 17: Send request
    response = http.request(request)
    #Step 18: Return the response body as Base64 encoded string
    Base64.strict_encode64(response.body)
  end
  end