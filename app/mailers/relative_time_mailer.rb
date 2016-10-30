class RelativeTimeMailer < ApplicationMailer
  def info_email(email, text)

      @server_time = DateTime.now
      Timecop.return do
        @real_time = DateTime.now
      end

      @text = text

      mail(to: email, subject: 'Rubymeetup Prague - relative time example', sparkpost_data: { api_key: ENV['SPARKPOST_API_KEY'] })
  end
end
