class Blob < ApplicationRecord
  self.primary_key = "id"

  # Keep it simple and declare the dependency
  has_one :blob_storage, foreign_key: :blob_id, dependent: :destroy
end