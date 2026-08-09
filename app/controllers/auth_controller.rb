class AuthController < ApplicationController
  def check_token
    auth_header = request.headers["Authorization"]

    if auth_header.blank?
      render json: { error: "Missing Authorization header" }, status: :unauthorized
      return
    end

    token = auth_header.split(" ").last

    if ApiToken.exists?(token: token)
      render json: { message: "Token is valid" }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  def generate_token
    new_token = SecureRandom.hex(32)

    record = ApiToken.create(token: new_token)

    if record.persisted?
      render json: { token: new_token }, status: :ok
    else
      render json: { error: "Failed to generate token", details: record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end