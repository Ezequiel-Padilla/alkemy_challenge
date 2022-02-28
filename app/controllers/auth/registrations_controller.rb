# frozen_string_literal: true

module Auth
  class RegistrationsController < ApplicationController
    include CreateSession

    def create
      @user = User.new(registration_params)

      @user.save ? success_user_created : error_user_save
    end

    private

    def success_user_created
      UserNotifierMailer.send_signup_email(@user).deliver_now
      render status: :created, template: 'auth/register'
    end

    def error_user_save
      render status: :unprocessable_entity, json: { errors: @user.errors.full_messages }
    end

    def registration_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation
      )
    end
  end
end
