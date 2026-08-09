class BlobStorage < ApplicationRecord
  # Let Rails handle the primary key natively. Just declare the foreign key link.
  belongs_to :blob, foreign_key: :blob_id
end