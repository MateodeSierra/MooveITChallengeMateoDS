require_relative 'memcached'
require 'socket'
require 'time'
require 'Monitor'


COMMANDS_THAT_NEED_TWO = [
    "set",
    "add",
    "replace",
    "append",
    "prepend",
    "cas",
]

SERVER_PORT = 2452

server = TCPServer.new('localhost', SERVER_PORT)
lock = Monitor.new

puts("MooveIT Challenge, by Mateo de Sierra")
puts("Server is online, listening on port #{SERVER_PORT}")
puts("To take down the server press CTRL + C")

loop do
    Thread.start(server.accept) do |client|
        client.puts("You have connected to the this Memcached server via port #{SERVER_PORT}.\n\r" \
            "Enter your command\r")
        loop do
            option = client.gets
            do_break = false
            if (option.nil? == false)
                option = option.downcase.strip
                command_parts = option.split
                command = command_parts[0]
                if COMMANDS_THAT_NEED_TWO.include?(command)
                    value = client.gets.strip
                    command_parts.append(value)
                end
                lock.synchronize do
                    result = handle_command(command_parts, HASH_DATA)
                    if (result == true)
                        client.puts("Connection is closing in 5 seconds\r")
                        sleep(5)
                        client.close
                        do_break = true
                        break
                    else
                        if (result.nil? == false)
                            result.each do |n|
                            client.puts(n)
                            end
                        end
                    end
                end
                break if do_break
            end
        end
    end
end


