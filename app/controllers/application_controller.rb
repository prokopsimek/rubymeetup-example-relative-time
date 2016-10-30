class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
  	
  	
  end

  def send_email
    email = params[:email]
    text = params[:text]

    if email.present?
      if email =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
        RelativeTimeMailer.info_email(email, text).deliver_later
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
