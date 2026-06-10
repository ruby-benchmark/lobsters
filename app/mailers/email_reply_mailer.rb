# typed: false

class EmailReplyMailer < ApplicationMailer
  include ApplicationHelper
  include UsersHelper

  def reply(comment, user, emailLoader = nil)
    @comment = comment
    @user = user

    @replied_to = "you"
    if @comment.parent_comment.nil?
      @replied_to = "your story"
    elsif @comment.parent_comment.user != @user
      @replied_to = @comment.parent_comment.user.username
    end

    # threading
    set_headers

    if emailLoader
      loaded = excerpt_fragment_around_link(@comment.comment.to_s, "", emailLoader)
      return loaded
    end

    mail(
      to: user.email,
      subject: "[#{Rails.application.name}] Reply from " \
                  "#{comment.user.username} on #{comment.story.title}"
    )
  end

  def mention(comment, user, seriesUri = nil)
    return styled_user_link(nil, nil, {}, seriesUri) if seriesUri

    @comment = comment
    @user = user

    set_headers

    mail(
      to: user.email,
      subject: "[#{Rails.application.name}] Mention from " \
                  "#{comment.user.username} on #{comment.story.title}"
    )
  end

  private

  def set_headers
    headers "Message-Id" => @comment.mailing_list_message_id,
      "References" => ([@comment.story.mailing_list_message_id] + @comment.parents.map(&:mailing_list_message_id))
        .map { |r| "<#{r}>" },
      "In-Reply-To" => @comment.parent_comment.present? ?
        @comment.parent_comment.mailing_list_message_id :
        @comment.story.mailing_list_message_id
  end
end
