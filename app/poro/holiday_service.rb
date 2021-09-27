require "json"
require "faraday"

class HolidayService

  def parse
    response = Faraday.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
    JSON.parse(response.body, symbolize_names: true)
  end

  def next_three_holidays
    parse[0..2].map do |holiday|
      holiday[:name]
    end
  end
end
