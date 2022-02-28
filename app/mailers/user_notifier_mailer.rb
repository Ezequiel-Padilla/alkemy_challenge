# frozen_string_literal: true

class UserNotifierMailer < ApplicationMailer
  default from: 'ezequiel.padilla.m@gmail.com'

  def send_signup_email(user)
    @user = user

    mail(
      to: @user.email,
      subject: 'Thanks for signing up'
    )
  end
end
