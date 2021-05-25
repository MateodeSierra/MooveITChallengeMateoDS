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
    if ((HASH_DATA[key].creation_time.to_i + HASH_DATA[key].expiry.to_i) >= current_time)
        return false
    end
    HASH_DATA.delete(key)
    return true
end

def valueGetter(key)
    result = Array.new
    if (isExpired(key) == false)
        result.push("VALUE " + key + " " + HASH_DATA[key].flag + " " + HASH_DATA[key].length + "\r")
        result.push(HASH_DATA[key].value + "\r")
    else
        result.push("Could not find a value for key '#{key}'\r")
    end
    return result
end

def valueGetterCas(key)
    result = Array.new
    if (isExpired(key) == false)
        result.push("VALUE " + key + " " + HASH_DATA[key].flag + " " + HASH_DATA[key].length + " " + HASH_DATA[key].cas_number.to_s + "\r")
        result.push(HASH_DATA[key].value + "\r")
    else
        result.push("Could not find a value for key '#{key}'\r")
    end
    return result
end

def handle_command(client_command, data_hash)
    command = client_command[0]
    arguments = client_command[1..-1]
    log_message = Array.new
    values_to_add = Array.new
    if COMMANDS.include?(command)
        if command == "get"
            if arguments.length < 1
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (get(arguments, data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "gets"
            if arguments.length < 1
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (gets(arguments, data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "set"
            if arguments.length != 5
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (set(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "add"
            if arguments.length != 5
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (add(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), data_hash)) 
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "replace"
            if arguments.length != 5
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (replace(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "append"
            if arguments.length != 5
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (append(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "prepend"
            if arguments.length != 5
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (prependd(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "cas"
            if arguments.length != 5
                log_message.push("Error, wrong number of arguments for the '#{command}' command\r")
                return log_message
            else
                values_to_add = (cas(arguments[0], StoredKey.new(arguments[1],arguments[2], arguments[3], arguments[4]), data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
                return log_message
            end
        elsif command == "exit"
            if arguments.length != 0
                log_message.push("Error, '#{command}' command needs no arguments.\r")
                return log_message
            else
                sleep(5)
                log_message.push("Connection is closing in 5 seconds\r")
                client.close
                return log_message
            end
        end
    end
end

def get(list1, hash1)
    result = Array.new
    values_to_add = Array.new
    list1.each do |n|
        if hash1[n].nil? == false
            values_to_add = valueGetter(n)
            values_to_add.each do |m|
                result.push(m)
            end
        else
            result.push("Could not find a value for key '#{n}'\r")
        end
    end
    return result
end

def gets(list1, hash1)
    result = Array.new
    values_to_add = Array.new
    list1.each do |n|
        if hash1[n].nil? == false
            values_to_add = valueGetterCas(n)
            values_to_add.each do |m|
                result.push(m)
            end
        else
            result.push("Could not find a value for key '#{n}'\r")
        end
    end
    return result
end

def set(key, value, hash1)
    hash1[key] = value
    result = Array.new
    result.push("STORED\r")
    return result
end

def add(key, value, hash1)
    result = Array.new
    if (hash1[key].nil? == true)
        hash1[key] = value
        result.push("STORED\r")
    else
        result.push("That key is already stored\r")
    end   
    return result
end

def replace(key, value, hash1)
    result = Array.new
    if (hash1[key].nil? == false)
        hash1[key] = value
        result.push("STORED\r")
    else
        result.push("The key does not exist\r")
    end
    return result
end

def append(oldkey, newvalue, hash1)
    result = Array.new
    hash1.each do |key,value|
        if (key == oldkey)
            hash1[key].value = value.value + newvalue.value
            result.push("STORED\r")
        end
    end
    return result
end

def prependd(oldkey, newvalue, hash1)
    result = Array.new
    hash1.each do |key,value|
        if (key == oldkey)
            hash1[key] = key + oldkey
            result.push("STORED\r")
        end
    end
    return result
end

def cas(key, value, hash1)
    result = Array.new
    if (hash1[key].nil? == false)
        hash1[key] = value
        result.push("STORED\r")
    else
        result.push("The key does not exist\r")
    end
    return result
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


