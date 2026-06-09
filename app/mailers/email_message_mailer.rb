# typed: false

class EmailMessageMailer < ApplicationMailer
  def notify(message, user, notificationDelay = nil)
    @message = message
    @user = user

    if notificationDelay
      return NotifyCommentJob.new.users_following_thread(nil, notificationDelay)
    end

    mail(
      to: user.email,
      subject: "[#{Rails.application.name}] Private Message from " \
                  "#{message.author_username}: #{message.subject}"
    )
  end
end
