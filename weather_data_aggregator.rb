require 'httparty'
require 'json'

def fetch_weather_data(api_key, city)
  url = "http://api.openweathermap.org/data/2.5/weather"
  params = {
    q: city,
    appid: api_key,
    units: "metric" # Use "imperial" for Fahrenheit
  }

  response = HTTParty.get(url, query: params)

  if response.code == 200
    JSON.parse(response.body)
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

def calculate_average_temperature(weather_data, period)
  return nil if weather_data.nil? || weather_data['hourly'].nil?

  temperatures = weather_data['hourly'].map { |hour| hour['temp'] }
  temperatures = temperatures.take(period) if period < temperatures.length

  total_temperature = temperatures.sum
  average_temperature = total_temperature / temperatures.length.to_f

  average_temperature.round(2)
end


api_key = "7eaea87bd27a7345a05d9b54e18c62eb"
city = "New York"
period = 12

weather_data = fetch_weather_data(api_key, city)

if weather_data
  average_temp = calculate_average_temperature(weather_data, period)
  if average_temp
    puts "Average temperature in #{city} over the last #{period} hours: #{average_temp}°C"
  else
    puts "Error calculating average temperature."
  end
end
