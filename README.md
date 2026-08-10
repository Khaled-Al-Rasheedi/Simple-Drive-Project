# Simple Drive API

A small, robust Rails API for storing and retrieving blob metadata and files with bearer token authentication and multi-backend distributed storage.

## Overview

This project implements a lightweight API for blob metadata handling, file storage, and token-protected access. The current focus is on:
- Issuing and validating bearer tokens
- Storing blob metadata and binary payloads
- Retrieving stored blob metadata and files by ID
- Routing files dynamically across multiple storage backends
- Ensuring data integrity with optimistic transaction rollbacks

## Features Completed

- Bearer token generation & validation
- Blob metadata tracking (ID, size, created_at, storage_backend)
- Base64/binary encoding and decoding support for file payloads
- Multi-backend storage routing:
  - Local file system storage
  - Database-backed storage (relational binary tables)
  - Amazon S3 Storage (Built strictly with raw HTTP/cryptography, without the AWS SDK)
  - FTP Server Storage 


## API Endpoints

### Generate Token

`POST /generate-token`

**Response:**
```json
{
  "token": "..."
}
```

### Validate Token

`GET /check-token`

**Headers:**
```text
Authorization: Bearer <token>
```

**Success Response:**
```json
{
  "message": "Token is valid"
}
```

### Store Blob Metadata & File

`POST /store?id=<id>&data=<data>`

**Headers:**
```text
Authorization: Bearer <token>
```

**Success Response:**
```json
{
  "id": "...",
  "size": 8,
  "storage_backend": "database",
  "created_at": "...",
  "updated_at": "..."
}
```

### Retrieve Blob Metadata & File

`GET /retrieve/<id>` or `GET /retrieve?id=<id>`

**Headers:**
```text
Authorization: Bearer <token>
```

**Success Response:**
```json
{
  "id": "...",
  "data": "base64_encoded_string_here...",
  "size": 8,
  "storage_backend": "database",
  "created_at": "...",
  "updated_at": "..."
}
```

---

## Setup & Installation

Follow these steps to set up the project locally on your machine:

### 1. Prerequisites
Ensure you have Ruby and Rails installed on your system.

### 2. Clone the Repository
```bash
git clone [https://github.com/Khaled-Al-Rasheedi/Simple-Drive-Project.git](https://github.com/Khaled-Al-Rasheedi/Simple-Drive-Project.git)
cd simple_drive_api
```

### 3. Install Dependencies
```bash
bundle install
```

### 4. Database Setup
Create and migrate the database:
```bash
bin/rails db:create
bin/rails db:migrate
```

### 5. Environment Configuration
Create a `.env` file in the root directory and set your environment variables to configure your active storage backend:
```env
STORAGE_BACKEND=database   # Options: local, database, s3, ftp

# Required if using the 's3' storage backend:
AWS_BUCKET_NAME=your_bucket_name
AWS_REGION=your_aws_region
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# Required if using the 'ftp' storage backend:
FTP_HOST=127.0.0.1
FTP_PORT=2121
FTP_USERNAME=admin
FTP_PASSWORD=1234
```

### 6. Run the Server
```bash
bin/rails server
```
The API will be available at `http://localhost:3000`, where you can interact with it using Postman or similar API software.

---

## Future Work
- Security features against popular cyberattacks
- Implement Unit Testing 
