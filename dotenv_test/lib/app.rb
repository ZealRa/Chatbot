require 'http'
require 'json'
require 'dotenv'

Dotenv.load

api_key = ENV["OPENAI_API_KEY"]
url = "https://api.openai.com/v1/completions"

headers = {
  "Content-Type" => "application/json",
  "Authorization" => "Bearer #{api_key}"
}

data = {
  "prompt" => "Je veux 5 parfums de glace différentaléatoires, en une liste",
  "max_tokens" => 20,
  "temperature" => 0.5,
  "model" => "babbage-002"
}

response = HTTP.post(url, headers: headers, body: data.to_json)
puts response
response_body = JSON.parse(response.body.to_s)
response_string = response_body['choices'][0]['text'].strip

puts "Voici 5 goûts de glace:"
puts response_string