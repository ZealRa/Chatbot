# ligne très importante qui appelle les gems.
require 'http'
require 'json'
require 'dotenv'
Dotenv.load('.env')

# Method to generate response from OpenAI API
def generate_response(prompt, api_key)
  url = "https://api.openai.com/v1/chat/completions"
  
  headers = {
    "Content-Type" => "application/json",
    "Authorization" => "Bearer #{api_key}"
  }
  
  data = {
    "messages" => [{"role" => "system", "content" => prompt}],
    "max_tokens" => 150,
    "temperature" => 0,
    "model" => "gpt-3.5-turbo"
  }
  
  response = HTTP.post(url, headers: headers, body: data.to_json)
  response_body = JSON.parse(response.body.to_s)
  
  if response_body.key?('choices') && response_body['choices'][0].key?('message') && response_body['choices'][0]['message'].key?('content')
    response_string = response_body['choices'][0]['message']['content'].strip
    return response_string
  else
    return "Error: Invalid response structure."
  end
end

# Method to interact with the bot
def bot_interaction(api_key, conversation_history)
  puts "Welcome to the Bot! Type 'exit' to quit."

  conversation_history = [{"role" => "system", "content" => "Parle moi des chats"}]
  
  loop do
    print "You: "
    user_input = gets.chomp
  
    break if user_input.downcase == 'exit'
  
    response = generate_response(user_input, api_key)
    puts "Bot: #{response}"
  
    # Store the interaction in history
    
    conversation_history << { "role" => "user", "content" => user_input }
    conversation_history << {"role"=> "ai", "content" => response }
  end
  
  puts "Exiting the Bot. Goodbye!"
end

# Example usage
def main
  api_key = ENV["OPENAI_API_KEY"]
  conversation_history = [{"role" => "system", "content" => "Parle moi des chats"}]
  bot_interaction(api_key, conversation_history )
end

main