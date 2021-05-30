require_relative 'stored_key.rb'
require 'socket'
require 'time'


def correct_length(value, supposed_length)
    if value.length == supposed_length.to_i
        return true
    end
    return false
end

def is_data_valid(client_command)
    if (client_command[1].is_number?)
        if (client_command[2].is_number?)
            if (client_command[3].is_number?)
                return true
            end
        end
    end
    return false
end

class Object
    def is_number?
      to_f.to_s == to_s || to_i.to_s == to_s
    end
end

def is_expired(key)
    current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    if ((HASH_DATA[key].creation_time.to_i + HASH_DATA[key].expiry.to_i) >= current_time)
        return false
    end
    HASH_DATA.delete(key)
    return true
end

def value_getter(key)
    result = Array.new
    if (is_expired(key) == false)
        result.push("VALUE " + key + " " + HASH_DATA[key].flag.to_s + " " + HASH_DATA[key].length.to_s + "\r")
        result.push(HASH_DATA[key].value + "\r")
    else
        result.push("Could not find a value for key '#{key}'\r")
    end
    return result
end

def value_getter_cas(key)
    result = Array.new
    if (is_expired(key) == false)
        result.push("VALUE " + key + " " + HASH_DATA[key].flag.to_s + " " + HASH_DATA[key].length.to_s + " " + HASH_DATA[key].cas_number.to_s + "\r")
        result.push(HASH_DATA[key].value + "\r")
    else
        result.push("Could not find a value for key '#{key}'\r")
    end
    return result
end

def message_stored()
    return ("STORED\r")
end

def error_message_exists()
    return ("EXISTS\r")
end

def error_message_not_found()
    return ("NOT_FOUND\r")
end

def error_message_length()
    return ("VALUE_LENGTH\r")
end

def error_message_command()
    return ("ARGUMENTS\r")
end

def error_message_data()
    return ("TYPE\r")
end


def handle_command(client_command, data_hash)
    command = client_command[0]
    arguments = client_command[1..-1]
    log_message = Array.new
    values_to_add = Array.new
    if COMMANDS.include?(command)
        if command == "get"
            if arguments.length < 1
                log_message.push(error_message_command())
                return log_message
            else
                values_to_add = (get(arguments, data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "gets"
            if arguments.length < 1
                log_message.push(error_message_command())
                return log_message
            else
                values_to_add = (gets(arguments, data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "set"
            if (is_data_valid(arguments) == false)
                log_message.push(error_message_data)
                return log_message
            elsif arguments.length != 5
                log_message.push(error_message_command())
                return log_message
            elsif (correct_length(arguments[4], arguments[3]) == false)
                log_message.push(error_message_length())
                return log_message
            else
                values_to_add = (set(arguments[0], arguments[4], arguments[1], arguments[2], arguments[3], data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "add"
            if (is_data_valid(arguments) == false)
                log_message.push(error_message_data)
                return log_message
            elsif arguments.length != 5
                log_message.push(error_message_command())
                return log_message
            elsif (correct_length(arguments[4], arguments[3]) == false)
                log_message.push(error_message_length())
                return log_message
            else
                values_to_add = (add(arguments[0], arguments[4], arguments[1], arguments[2], arguments[3], data_hash)) 
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "replace"
            if (is_data_valid(arguments) == false)
                log_message.push(error_message_data)
                return log_message
            elsif arguments.length != 5
                log_message.push(error_message_command())
                return log_message
            elsif (correct_length(arguments[4], arguments[3]) == false)
                log_message.push(error_message_length())
                return log_message
            else
                values_to_add = (replace(arguments[0], arguments[4], arguments[1], arguments[2], arguments[3], data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "append"
            if (is_data_valid(arguments) == false)
                log_message.push(error_message_data)
                return log_message
            elsif arguments.length != 5
                log_message.push(error_message_command())
                return log_message
            elsif (correct_length(arguments[4], arguments[3]) == false)
                log_message.push(error_message_length())
                return log_message
            else
                values_to_add = (append(arguments[0], arguments[4], arguments[1], arguments[2], arguments[3], data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "prepend"
            if (is_data_valid(arguments) == false)
                log_message.push(error_message_data)
                return log_message
            elsif arguments.length != 5
                log_message.push(error_message_command())
                return log_message
            elsif (correct_length(arguments[4], arguments[3]) == false)
                log_message.push(error_message_length())
                return log_message
            else
                values_to_add = (prependd(arguments[0], arguments[4], arguments[1], arguments[2], arguments[3], data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
            end
        elsif command == "cas"
            if (is_data_valid(arguments) == false)
                log_message.push(error_message_data)
                return log_message
            elsif arguments.length != 6
                log_message.push(error_message_command())
                return log_message
            elsif (correct_length(arguments[5], arguments[3]) == false)
                log_message.push(error_message_length())
                return log_message
            else
                values_to_add = (cas(arguments[0], arguments[5], arguments[4], data_hash))
                values_to_add.each do |n|
                    log_message.push(n)
                end
                return log_message
            end
        elsif command == "exit"
            if arguments.length != 0
                log_message.push(error_message_command())
                return log_message
            else
                return true
            end
        end
    end
end

def get(list_of_keys, data_hash)
    result = Array.new
    values_to_add = Array.new
    list_of_keys.each do |n|
        if data_hash[n].nil? == false
            values_to_add = value_getter(n)
            values_to_add.each do |m|
                result.push(m)
            end
        else
            result.push(error_message_not_found)
        end
    end
    return result
end

def gets(list_of_keys, data_hash)
    result = Array.new
    values_to_add = Array.new
    list_of_keys.each do |n|
        if data_hash[n].nil? == false
            values_to_add = value_getter_cas(n)
            values_to_add.each do |m|
                result.push(m)
            end
        else
            result.push(error_message_not_found)
        end
    end
    return result
end

def set(key, value, flag, expiry, length, data_hash)
    data_hash[key] = StoredKey.new(flag, expiry, length, value)
    result = Array.new
    result.push(message_stored)
    return result
end

def add(key, value, flag, expiry, length, data_hash)
    result = Array.new
    if (data_hash[key].nil? == true)
        data_hash[key] = StoredKey.new(flag, expiry, length, value)
        result.push(message_stored)
    else
        result.push(error_message_exists)
    end   
    return result
end

def replace(key, value, newflag, newexpiry, newlength, data_hash)
    result = Array.new
    if (data_hash[key].nil? == false)
        data_hash[key].value = value
        data_hash[key].flag = newflag
        data_hash[key].length = newlength.to_i
        data_hash[key].expiry = newexpiry
        data_hash[key].updateCreationTime
        data_hash[key].update_cas
        result.push(message_stored)
    else
        result.push(error_message_not_found)
    end
    return result
end

def append(oldkey, newvalue, newflag, newexpiry, newlength, data_hash)
    result = Array.new
    data_hash.each do |key,value|
        if (key == oldkey)
            data_hash[key].value = value.value + newvalue
            data_hash[key].flag = newflag
            data_hash[key].length = data_hash[key].length.to_i + newlength.to_i
            data_hash[key].expiry = newexpiry
            data_hash[key].updateCreationTime
            data_hash[key].update_cas
            result.push(message_stored)
        end
    end
    return result
end

def prependd(oldkey, newvalue, newflag, newexpiry, newlength, data_hash)
    result = Array.new
    data_hash.each do |key,value|
        if (key == oldkey)
            data_hash[key].value = newvalue + value.value
            data_hash[key].flag = newflag
            data_hash[key].length = data_hash[key].length.to_i + newlength.to_i
            data_hash[key].expiry = newexpiry
            data_hash[key].updateCreationTime
            data_hash[key].update_cas
            result.push(message_stored)
        end
    end
    return result
end

def cas(key, value, cas, data_hash)
    result = Array.new
    if (data_hash[key].nil? == false)
        if (data_hash[key].cas_number == cas.to_i)
            data_hash[key].value = value
            result.push(message_stored)
        else
            result.push(error_message_exists)
        end
    else
        result.push(error_message_not_found)
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


