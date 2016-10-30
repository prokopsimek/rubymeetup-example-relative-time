class RelativeTimeMailer < ApplicationMailer
  def info_email(email)

      @server_time = DateTime.now
      Timecop.return do
        @real_time = DateTime.now
      end

      mail(to: email, subject: 'Rubymeetup Prague - relative time example')
  end
end
