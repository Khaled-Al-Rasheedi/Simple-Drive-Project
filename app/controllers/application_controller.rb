class ApplicationController < ActionController::API
  include TokenAuthenticatable 
    #To check for Bearer token before storing or retrieving blobs
end
