# frozen_string_literal: true

module Auth
  class SessionsController < ApplicationController
    include CreateSession
    before_action :authenticate_user!, only: %i[destroy validate_token]

    def create
      @user = User.find_by(email: params[:user][:email])

      if @user && @user&.authenticate(params[:user][:password])
        @token = jwt_session_create(@user)
        return success_session_created if @token

        error_token_create
      else
        error_invalid_credentials
      end
    end

    def validate_token
      @token = request.headers['Authorization']
      @user = current_user
      @user ? success_valid_token : error_invalid_credentials
    end

    def destroy
      headers = request.headers['Authorization'].split(' ').last
      session = Session.find_by(token: JsonWebToken.decode(headers)[:token])
      session.close
      success_session_destroy
    end

    private

    def success_session_created
      response.headers['Authorization'] = "Bearer #{@token}"
      render status: :created, template: 'auth/session'
    end

    def success_valid_token
      response.headers['Authorization'] = "Bearer #{@token}"
      render status: :ok, template: 'auth/session'
    end

    def success_session_destroy
      render status: :ok, json: {
        message: I18n.t('messages.controllers.auth.logout')
      }
    end

    def error_invalid_credentials
      render status: :unauthorized, json: {
        errors: [I18n.t('errors.controllers.auth.invalid_credentials')]
      }
    end

    def error_token_create
      render status: :unprocessable_entity, json: {
        errors: [I18n.t('errors.controllers.auth.token_not_created')]
      }
    end

    def error_insufficient_params
      render status: :unprocessable_entity, json: {
        errors: [I18n.t('errors.controllers.insufficient_params')]
      }
    end
  end
end
