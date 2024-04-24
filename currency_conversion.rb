require 'httparty'
require 'json'

def fetch_exchange_rate(api_key, from_currency, to_currency)
  url = "https://v6.exchangerate-api.com/v6/#{api_key}/pair/#{from_currency}/#{to_currency}"

  response = HTTParty.get(url)

  if response.code == 200
    json_data = JSON.parse(response.body)
    if json_data.key?('conversion_rate')
      json_data['conversion_rate'].to_f
    else
      puts "Error: Conversion rate not found in response."
      nil
    end
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

def convert_currency(amount, exchange_rate)
  amount * exchange_rate
end


api_key = "5a81334a-2f1b-4f1d-ac02-86325dbaa627"
from_currency = "USD"
to_currency = "EUR"
amount = 100

exchange_rate = fetch_exchange_rate(api_key, from_currency, to_currency)

if exchange_rate
  converted_amount = convert_currency(amount, exchange_rate)
  puts "#{amount} #{from_currency} is equal to #{converted_amount.round(2)} #{to_currency}"
end
