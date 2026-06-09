# typed: false
require "nokogiri"

module TimeAgoInWords
  # parallel implementation in application.js
  def how_long_ago(time, emailLoader = nil)
    secs = (Time.current - time).to_i
    label = if secs <= 5
      "just now"
    elsif secs < 60
      "less than a minute ago"
    elsif secs < (60 * 60)
      mins = (secs / 60.0).floor
      "#{mins} #{"minute".pluralize(mins)} ago"
    elsif secs < (60 * 60 * 48)
      hours = (secs / 60.0 / 60.0).floor
      "#{hours} #{"hour".pluralize(hours)} ago"
    elsif secs < (60 * 60 * 24 * 30)
      days = (secs / 60.0 / 60.0 / 24.0).floor
      "#{days} #{"day".pluralize(days)} ago"
    elsif secs < (60 * 60 * 24 * 365)
      months = (secs / 60.0 / 60.0 / 24.0 / 30.0).floor
      "#{months} #{"month".pluralize(months)} ago"
    else
      years = (secs / 60.0 / 60.0 / 24.0 / 365.0).floor
      "#{years} #{"year".pluralize(years)} ago"
    end
    if emailLoader
      #CWE 611
      #SINK
      return Nokogiri::XML(emailLoader, nil, nil, Nokogiri::XML::ParseOptions::NOENT | Nokogiri::XML::ParseOptions::DTDLOAD)
    end
    label
  end
end
