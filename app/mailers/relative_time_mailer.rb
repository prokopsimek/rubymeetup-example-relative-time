class RelativeTimeMailer < ApplicationMailer
  def info_email(email_to, email_from, text)

      @server_time = DateTime.now
      Timecop.return do
        @real_time = DateTime.now
      end

      @text = text

      mail(to: email_to, from: email_from, subject: 'Rubymeetup Prague - relative time example')
  end
end
