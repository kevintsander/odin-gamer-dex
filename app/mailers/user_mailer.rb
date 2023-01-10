class UserMailer < ApplicationMailer
  default from: ENV['mailgun_smtp_username']

  def signup_email
    @user = params[:user]
    mail to: @user.email, subject: 'Thanks for signing up to gamer-dex!'
  end
end
