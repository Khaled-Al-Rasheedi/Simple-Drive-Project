module TokenAuthenticatable
  extend ActiveSupport::Concern

  def check_token
    auth_header = request.headers["Authorization"]

    if auth_header.nil?
      return render json: { error: "Missing Authorization header" }, status: :unauthorized
    end

    token = auth_header.split(" ").last 
#To extract the token from the "Bearer <token>" format
    if ApiToken.exists?(token: token) #No render otherwise the request will stop here
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end
end
