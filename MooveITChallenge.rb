require 'socket'

server = TCPServer.new('localhost', 2452)

puts ""

loop do
  client = server.accept
  client.puts "Hello !"
  client.puts "Time is #{Time.now} GMT" 
  client.close
end
