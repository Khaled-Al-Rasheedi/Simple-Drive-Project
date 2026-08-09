# Simple Drive API

A small Rails API for storing and retrieving blob metadata with bearer token authentication.

## Overview

This project implements a lightweight API for blob metadata handling and token-protected access. The current focus is on:
- issuing bearer tokens
- validating bearer tokens
- storing blob metadata
- retrieving stored blob metadata by ID

## Features Completed

- Bearer token generation
- Bearer token validation
- Blob metadata storage
- Blob metadata retrieval
- Local file storage
- Added Base64/binary decoding support for data
- local file storage backend
- database-backed storage 

## API Endpoints

### Generate token

`POST /generate-token`

Response:
```json
{
  "token": "..."
}
```

### Validate token

`GET /check-token`

Headers:
```text
Authorization: Bearer <token>
```

Success response:
```json
{
  "message": "Token is valid"
}
```

### Store blob metadata

`POST /store?id=<id>&data=<data>`

Headers:
```text
Authorization: Bearer <token>
```

Success response:
```json
{
  "id": "...",
  "size": 8,
  "storage_backend": "example",
  "created_at": "...",
  "updated_at": "..."
}
```

### Retrieve blob metadata

`GET /retrieve/<id>` or `GET /retrieve?id=<id>`

Headers:
```text
Authorization: Bearer <token>
```

Success response:
```json
{
  "id": "...",
  "size": 8,
  "storage_backend": "example",
  "created_at": "...",
  "updated_at": "..."
}
```

## Setup

```bash
bundle install
bin/rails db:create db:migrate
bin/rails server
```

## Future work

- Implement Amazon S3-compatible storage
- Improve request validation and error handling
