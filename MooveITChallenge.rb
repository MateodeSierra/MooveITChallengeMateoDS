require 'socket'
require 'time'

class Command
    def initialize(name, number_of_argument, client)
        @name = name
        @number_of_argument = number_of_argument
    end

    def puts_error
        client.puts("Error, wrong number of arguments for the '#{name}' command\r")
    end

    def number_of_argument
        @number_of_argument
    end

    def name
        @name
    end
end

class StoredKey
    @@next_cas_number = 0

    def initialize(flag, expiry, length, value)
        @length = length
        @expiry = expiry
        @value = value
        @flag = flag
        @creation_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @cas_number = @@next_cas_number + 1
        @@next_cas_number += 1
    end

    def length
        @length
    end

    def expiry
        @expiry
    end

    def value
        @value
    end

    def creation_time
        @creation_time
    end

    def flag
        @flag
    end

    def cas_number
        @cas_number
    end

    def flag=(flag)
        @flag = flag
    end

    def value=(value)
        @value = value
    end

    def  expiry=(expiry)
        @expiry = expiry
    end

    def updateCreationTime
        @creation_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

end

#methods

def is_data_valid(list1, client)
    if list1.length() == 5
        if (list1[0].nil? == false) && (list1[1].nil? == false) && (list1[2].nil? == false) && (list1[3].nil? == false) && (list1[4].nil? == false)
            if (list1[0].is_a? String) && (list1[1].is_a? String) && (list1[2].is_a? Numeric) && (list1[3].is_a? Numeric) && (list1[4].is_a? Numeric)
                if (list1[1].length <= list1[4])
                    return true
                end
            end
        end
    elsif list1.length() == 2
        if (list1[0].nil? == false) && (list1[1].nil? == false)
            if (list1[0].is_a? String) && (list1[0].is_a? String)
                return true
            end
        end
    elsif list1.length() == 1
        if (list1[0].is_a? String)
            return true
        end
    end
end



    


def isExpired(key)
    current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    if ((key.creation_time + key.expiry) >= current_time)
        return false
    end
    return true
end

def valueGetter(key, client)
    client.print("VALUE ")
    client.print(key + " ")
    client.print(HASH_DATA[key].flag + " ")
    client.puts(HASH_DATA[key].length + "\r")
    client.puts(HASH_DATA[key].value + "\r")
end

def valueGetterCas(key, client)
    client.print("VALUE ")
    client.print(key + " ")
    client.print(HASH_DATA[key].flag + " ")
    client.print(HASH_DATA[key].length + " ")
    client.puts(HASH_DATA[key].cas_number.to_s + "\r")
    client.puts(HASH_DATA[key].value + "\r")
end

def handle_command(client_command, hash1, client)
    command_parts = client_command.split
    command = command_parts[0]
    arguments = command_parts[1..-1]
    if COMMANDS.include?(command)
        if command == "get"
            if arguments.length < 1
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                get(arguments, hash1, client)
            end
        elsif command == "gets"
            if arguments.length < 1
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                gets(arguments, hash1, client)
            end
        elsif command == "set"
            value = client.gets.strip
            arguments.append(value)
            if arguments.length != 5
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                set(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), hash1, client) #aca debe pasar un objeto key no solo el value
            end
        elsif command == "add"
            value = client.gets.strip
            arguments.append(value)
            if arguments.length != 5
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                add(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), hash1, client) #aca debe pasar un objeto key no solo el value
            end
        elsif command == "replace"
            value = client.gets.strip
            arguments.append(value)
            if arguments.length != 5
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                replace(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), hash1, client) #aca debe pasar un objeto key no solo el value
            end
        elsif command == "append"
            value = client.gets.strip
            arguments.append(value)
            if arguments.length != 5
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                append(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), hash1, client)
            end
        elsif command == "prepend"
            value = client.gets.strip
            arguments.append(value)
            if arguments.length != 5
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                prependd(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), hash1, client)
            end
        elsif command == "cas"
            value = client.gets.strip
            arguments.append(value)
            if arguments.length != 5
                client.puts("Error, wrong number of arguments for the '#{command}' command\r")
            else
                cas(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), hash1, client)
            end
        elsif command == "exit"
            if arguments.length != 0
                client.puts("Error, '#{command}' command needs no arguments.\r")
            else
                client.puts("Connection is closing in 5 seconds\r")
                sleep(5)
                return true
                client.close
            end
        end
    end
end

def get(list1, hash1, client)
    list1.each do |n|
        if hash1[n].nil? == false
            valueGetter(n, client)
        else
            client.puts("Could not find a value for key '#{n}'\r")
        end
    end
    return
end

def gets(list1, hash1, client)
    list1.each do |n|
        if hash1[n].nil? == false
            valueGetter(n, client)
        else
            client.puts("Could not find a value for key '#{n}'\r")
        end
    end
    return
end

def set(key, value, hash1, client)
    hash1[key] = value
    client.puts("STORED\r")
end

def add(key, value, hash1, client)
    if (hash1[key].nil? == true)
        hash1[key] = value
        client.puts("STORED\r")
    else
        client.puts("That key is already stored\r")
    end   
end

def replace(key, value, hash1, client)
    if (hash1[key].nil? == false)
        hash1[key] = value
        client.puts("STORED\r")
    else
        client.puts("The key does not exist\r")
    end
end

def append(oldkey, newvalue, hash1, client)
    #agrega data al final de la data guardada, no se pasa del limite de caracteres
    hash1.each do |key,value|
        if (key == oldkey)
            hash1[key].value = value.value + newvalue.value
            client.puts("STORED\r")
        end
    end
    return
end

def prependd(oldkey, newvalue, hash1, client)
    #lo mismo que append pero antes de la data existente
    hash1.each do |key,value|
        if (key == oldkey)
            hash1[key] = key + oldkey
            client.puts("STORED\r")
        end
    end
    return
end

def cas(key, value, hash1, client)
    #check and set, guarda data, pero solo si fuiste vos el ultimo que la updateo desde que vos la leiste 
    #mientras que no implemente muchos clientes esto es solo un replace
    if (hash1[key].nil? == false)
        hash1[key] = value
        client.puts("STORED\r")
    else
        client.puts("The key does not exist\r")
    end
end

COMMANDS = [
    "get",
    "gets",
    "set",
    "add",
    "replace",
    "append",
    "prepend",
    "cas",
    "exit",
]

HASH_DATA = {}

SERVER_PORT = 2452
server = TCPServer.new('localhost', SERVER_PORT)
#necesito crear el array o diccionario a donde van a ir los datos

puts("MooveIT Challenge, by Mateo de Sierra")
puts("Server is online, litening on port #{SERVER_PORT}")
puts("To take down the server press CTRL + C")

loop do
  client = server.accept
  client.puts("You have connected to the this Memcached server via port #{SERVER_PORT}." \
  "Please enter one of the implemented commands, if you enter " \
  "one of the associated numbers an example on how to use it will be printed\r")

  client.puts("Available commands:\r")
  client.puts("1. get\r")
  client.puts("2. gets\r")
  client.puts("3. set\r")   #
  client.puts("4. add\r")  #
  client.puts("5. replace\r")  #
  client.puts("6. append\r")  #
  client.puts("7. prepend\r")   #
  client.puts("8. cas\r")
  client.puts("9. Exit client\r")
  client.puts("Your choice: \r")

  loop do
    option = client.gets.strip
    if (handle_command(option.downcase, HASH_DATA, client))
        break
    end
  end
end

