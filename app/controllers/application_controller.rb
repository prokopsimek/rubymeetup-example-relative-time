class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
  	
  	
  end

  def send_email
    email_from = params[:email_from]
    email_to = params[:email_to]
    text = params[:text]

    if email_to.present? && email_from.present?
      if email_to =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ && email_from =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
        RelativeTimeMailer.info_email(email_to, email_from, text).deliver_later
        notice = 'Email sent, check your inbox'
      else
        notice = 'Invalid email format'
      end
    else
      notice = 'Something missing'
    end

    redirect_to root_path, notice: notice
  end

  def time
    
  end
end
