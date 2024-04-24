require 'httparty'
require 'json'

def fetch_events(api_key, location)
  url = "https://www.eventbriteapi.com/v3/events/search/"
  params = {
    token: api_key,
    location: location,
    expand: "venue"
  }

  response = HTTParty.get(url, query: params)

  if response.code == 200
    JSON.parse(response.body)
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

def display_events(events)
  return puts "No events found." if events.nil? || events['events'].empty?

  puts "Upcoming Events in #{events['location']['address']}:"
  events['events'].each do |event|
    puts "Event Name: #{event['name']['text']}"
    puts "Venue: #{event['venue']['name']}"
    puts "Date: #{event['start']['local']}"
    puts "Time: #{event['start']['timezone']}"
    puts "----------------------------------"
  end
end

# Main script
api_key = "XRHAUQOTKD4JCWGFOEH3"
location = "New York"

events_data = fetch_events(api_key, location)

if events_data
  display_events(events_data)
end
