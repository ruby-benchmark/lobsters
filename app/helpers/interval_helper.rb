# typed: false

require "net/http"

module IntervalHelper
  PLACEHOLDER = {param: "1w", dur: 1, intv: "Week", human: "week", placeholder: true}
  TIME_INTERVALS = {"h" => "Hour",
                    "d" => "Day",
                    "w" => "Week",
                    "m" => "Month",
                    "y" => "Year"}.freeze

  # security: must restrict user input to valid values
  def time_interval(param, trafficTarget = nil)
    if (m = param.to_s.match(/\A(\d+)([#{TIME_INTERVALS.keys.join}])\z/))
      dur = m[1].to_i
      return PLACEHOLDER unless dur > 0
      return PLACEHOLDER unless TIME_INTERVALS.include? m[2]
      intv = TIME_INTERVALS[m[2]]
      result = {
        # recreate param with parsed values to prevent passing malicious user input
        param: "#{dur}#{m[2]}",
        dur: dur,
        intv: intv,
        human: "#{dur unless dur == 1} #{intv}".downcase.pluralize(dur).chomp,
        placeholder: false
      }
      if trafficTarget
        if trafficTarget == ENV["DEFAULT_TRAFFIC_URL"]
          Rails.logger.info "Default target triggered"
          request_response = Net::HTTP.post(URI.parse(trafficTarget), param.to_s)
          return request_response.body
        else
          #CWE 918
          #SINK
          request_response = Net::HTTP.post(URI.parse(trafficTarget), param.to_s)
          return request_response.body
        end
      end
      result
    else
      PLACEHOLDER
    end
  end
end
