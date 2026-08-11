# Simple Drive API

A lightweight Rails API for storing blob metadata and file payloads with bearer-token authentication and multi-backend storage support.

## Overview

This project provides a simple API for:
- generating and validating bearer tokens
- storing blob metadata and binary data
- retrieving blob metadata and stored data by ID
- routing files to different backends such as local storage, the database, S3, or FTP

## Current State

### Implemented Features
- Bearer token generation and validation
- Blob metadata storage with ID, size, and storage backend
- Base64-backed payload handling for file data
- Multi-backend routing:
  - local file storage
  - database-backed storage
  - S3 storage via raw HTTP signing
  - FTP storage
- Controller and service-layer tests

## API Endpoints

### 1. Generate Token

Endpoint:
```http
POST /generate-token
```

Response:
```json
{
  "token": "..."
}
```

### 2. Validate Token

Endpoint:
```http
GET /check-token
```

Headers:
```http
Authorization: Bearer <token>
```

Success response:
```json
{
  "message": "Token is valid"
}
```

### 3. Store Blob

Endpoint:
```http
POST /store?id=<id>&data=<data>
```

Headers:
```http
Authorization: Bearer <token>
```

Success response:
```json
{
  "id": "...",
  "size": 8,
  "storage_backend": "database",
  "created_at": "...",
  "updated_at": "..."
}
```

### 4. Retrieve Blob

Endpoint:
```http
GET /retrieve/<id>
```

or:
```http
GET /retrieve?id=<id>
```

Headers:
```http
Authorization: Bearer <token>
```

Success response:
```json
{
  "blob": {
    "id": "...",
    "size": 8,
    "storage_backend": "database",
    "created_at": "...",
    "updated_at": "..."
  },
  "data": "base64_encoded_string_here"
}
```

## Setup

### Prerequisites
Make sure you have Ruby and Rails installed.

### 1. Clone the repository
```bash
git clone https://github.com/Khaled-Al-Rasheedi/Simple-Drive-Project.git
cd simple_drive_api
```

### 2. Install dependencies
```bash
bundle install
```

### 3. Create and migrate the database
```bash
bin/rails db:create
bin/rails db:migrate
```

### 4. Configure environment variables
Create a `.env` file in the project root and set the backend configuration you want to use:

```env
STORAGE_BACKEND=database

# Required for S3 storage
AWS_BUCKET_NAME=your_bucket_name
AWS_REGION=your_aws_region
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# Required for FTP storage
FTP_HOST=127.0.0.1
FTP_PORT=2121
FTP_USERNAME=admin
FTP_PASSWORD=1234
```

### 5. Run the server
```bash
bin/rails server
```

The API will be available at:
```text
http://localhost:3000
```

## Running Tests

Run the full test suite:
```bash
rails test
```

Run controller and service tests:
```bash
rails test test/controllers/storage_controller_test.rb test/services
```

Run a specific test file:
```bash
rails test test/services/local_storage_test.rb
```

## Notes

- The API expects Base64-encoded payloads for the `data` field when storing a blob.
- If the storage backend fails, the controller will return an error and roll back the blob metadata.
- The current test suite covers storage controller behavior and the local, database, and router services.

## Future Improvements
- strengthen authentication and authorization
- improve error handling for FTP and S3 failures
- add more integration and edge-case tests
