require 'telegram/bot'
require 'net/http'
require 'json'

$token = ENV['TOKEN']
$url = ENV['URL']

$auto = false

def automatic
    p $auto
    while $auto do
      Telegram::Bot::Client.run($token)do |bot|
        uri = URI($url)
        response = Net::HTTP.get(uri)
        data =  JSON.parse(response)['response']
        text= ''
        data.each do |key, value|
          key.each do |key, value|
            text << "#{key}: #{value} \n"
          end
        end
        bot.api.send_message(
            chat_id: 257133028,
            text: "#{text}"
        )
      end
      sleep 5
    end
  end

Telegram::Bot::Client.run($token) do |bot|
    bot.listen do |message|
      case message.text
        when '/start'
          msg = 'Hey welcome to  fscrapper, to see available commands press /help'
          bot.api.send_message(chat_id: message.chat.id, text: msg)
        when '/help'
          msg = ['/mc to manually get live forex ','/ac to automatically get live forex data']
          msg.each { |msg| bot.api.send_message(chat_id: message.chat.id, text: msg) }
        when '/mc'
          uri = URI($url)
          response = Net::HTTP.get(uri)
          data =  JSON.parse(response)['response']
          text= ''
          data.each do |key, value|
              key.each do |key, value|
                  text << "#{key}: #{value} \n"
              end
          end
          print(message.chat.id)
          bot.api.send_message(chat_id: message.chat.id, text: "#{text}")
        when '/s'
            $auto = false
            p "clicked stop #{$auto}"
        when '/ac'
          $auto = true
          print('Auto set to true')
          automatic
        end
    end
end


