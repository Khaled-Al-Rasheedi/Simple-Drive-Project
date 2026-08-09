Rails.application.routes.draw do
  get "/check-token", to: "auth#check_token" #Check if Token is valid
  post "/generate-token", to: "auth#generate_token" #To generate a new token
  post "/store", to: "storage#store" #To store a blob
  get "/retrieve(/:id)", to: "storage#retrieve" #To retrieve a blob

end