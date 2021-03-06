require_relative 'collector'
require_relative 'constants'
require_relative 'storage'
require_relative 'validation'
require_relative 'stored_key'
require_relative 'message_codes'
require_relative 'handler'


class Server

    def initialize(port,lock)
        @port = port
        @lock = lock
    end

    def start_server()
        @server = TCPServer.new('localhost', @port)
        puts("MooveIT Challenge, by Mateo de Sierra")
        puts("Server is online, listening on port #{SERVER_PORT}")
        puts("To take down the server press CTRL + C")
    end

    def start_listening()
        loop do
            Thread.start(@server.accept) do |client|
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
                        @lock.synchronize do
                            result = handle_command(command_parts, HASH_DATA)
                            if (result == true)
                                client.print("Connection closed\r\n")
                                sleep(1)
                                client.close
                                do_break = true
                                break
                            else
                                if (result.nil? == false)
                                    result.each do |n|
                                    client.print(n)
                                    end
                                end
                            end
                        end
                        break if do_break
                    end
                end
            end
        end
    end
end
        


    