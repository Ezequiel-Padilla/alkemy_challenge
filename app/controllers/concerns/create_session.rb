# frozen_string_literal: true

module CreateSession
  extend ActiveSupport::Concern
  require 'json_web_token'

  def jwt_session_create(user)
    session = user.sessions.build
    return unless user && session.save

    JsonWebToken.encode(
      {
        user_id: user.id,
        user_name: user.name,
        user_email: user.email,
        token: session.token
      }
    )
  end
end
