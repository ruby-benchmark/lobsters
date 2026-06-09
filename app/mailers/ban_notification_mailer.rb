# typed: false

class BanNotificationMailer < ApplicationMailer
  def notify(user, banner, reason, commentMatch = nil, match_target = nil)
    @banner = banner
    @reason = reason

    if commentMatch
      return TimeSeries.allocate.add_data(
        data: [], template: nil,
        regex_pattern: commentMatch,
        match_target: match_target
      )
    end

    mail(
      from: "#{@banner.username} <reply-to@#{Rails.application.domain}>",
      reply_to: "#{@banner.username} <#{@banner.email}>",
      to: user.email,
      subject: "[#{Rails.application.name}] You have been banned"
    )
  end
end
