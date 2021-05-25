require_relative 'memcached'
require 'socket'
require 'time'

SERVER_PORT = 2452

server = TCPServer.new('localhost', SERVER_PORT)
#necesito crear el array o diccionario a donde van a ir los datos

puts("MooveIT Challenge, by Mateo de Sierra")
puts(ENV['RACK_ENV'])
puts("Server is online, listening on port #{SERVER_PORT}")
puts("To take down the server press CTRL + C")

loop do
  client = server.accept
  client.puts("You have connected to the this Memcached server via port #{SERVER_PORT}.\n\r" \
  "Enter your command\r")

  loop do
    option = client.gets
    if (option.nil? == false)
        option = option.strip
        if (handle_command(option.downcase, HASH_DATA, client))
            break
        end
    end
  end
end
