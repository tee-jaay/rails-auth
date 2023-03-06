class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:authenticate]

  def authenticate
    if params[:auth_type] == 'signup'
      user = User.create(user_params)
      if user.valid?
        token = encode_token({ user_id: user.id, email: user.email, username: user.username })
        render json: { token: token }, status: :created
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    elsif params[:auth_type] == 'signin'
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = encode_token({ user_id: user.id, email: user.email, username: user.username })
        render json: { token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    else
      render json: { error: 'Invalid authentication type' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :username, :role).merge(role: 'user')
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
