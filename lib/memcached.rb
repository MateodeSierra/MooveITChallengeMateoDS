require_relative 'stored_key.rb'
require 'socket'
require 'time'


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

def correct_length(value, supposed_length)
    if value.length == supposed_length.to_i
        return true
    end
    return false
end

def is_data_numbers(client_command)
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
        result.push("VALUE " + key + " " + HASH_DATA[key].flag.to_s + " " + HASH_DATA[key].length.to_s + "\r\n")
        result.push(HASH_DATA[key].value + "\r\n")
    end
    return result
end

def value_getter_cas(key)
    result = Array.new
    if (is_expired(key) == false)
        result.push("VALUE " + key + " " + HASH_DATA[key].flag.to_s + " " + HASH_DATA[key].length.to_s + " " + HASH_DATA[key].cas_number.to_s + "\r\n")
        result.push(HASH_DATA[key].value + "\r\n")
    end
    return result
end

def message_stored()
    return ("STORED\r\n")
end

def message_end()
    return ("END\r\n")
end

def error_message_exists()
    return ("EXISTS\r\n")
end

def error_message_not_found()
    return ("NOT_FOUND\r\n")
end

def error_message_length()
    return ("VALUE_LENGTH\r\n")
end

def error_message_command()
    return ("ARGUMENTS\r\n")
end

def error_message_data()
    return ("TYPE\r\n")
end

def error_message_error()
    return ("ERROR\r\n")
end

def is_get_valid(arguments)
    log_message = Array.new
    if arguments.length < 1
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_gets_valid(arguments)
    log_message = Array.new
    if arguments.length < 1
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_set_valid(arguments)
    log_message = Array.new
    if (is_data_numbers(arguments) == false)
        log_message.push(error_message_error())
        return log_message
    elsif arguments.length != 5
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[4], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_add_valid(arguments)
    log_message = Array.new
    if (is_data_numbers(arguments) == false)
        log_message.push(error_message_error())
        return log_message
    elsif arguments.length != 5
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[4], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_replace_valid(arguments)
    log_message = Array.new
    if (is_data_numbers(arguments) == false)
        log_message.push(error_message_error())
        return log_message
    elsif arguments.length != 5
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[4], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_append_valid(arguments)
    log_message = Array.new
    if (is_data_numbers(arguments) == false)
        log_message.push(error_message_error())
        return log_message
    elsif arguments.length != 5
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[4], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_prepend_valid(arguments)
    log_message = Array.new
    if (is_data_numbers(arguments) == false)
        log_message.push(error_message_error())
        return log_message
    elsif arguments.length != 5
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[4], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_cas_valid(arguments)
    log_message = Array.new
    if (is_data_numbers(arguments) == false)
        log_message.push(error_message_error())
        return log_message
    elsif arguments.length != 6
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[5], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def handle_command(client_command, data_hash)
    command = client_command[0]
    arguments = client_command[1..-1]
    log_message = Array.new
    values_to_add = Array.new
    if COMMANDS.include?(command)
        if command == "get"
            values_to_add = (get(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "gets"
            values_to_add = (gets(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "set"
            values_to_add = (set(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "add"
            values_to_add = (add(arguments, data_hash)) 
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "replace"
            values_to_add = (replace(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "append"
            values_to_add = (append(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "prepend"
            values_to_add = (prependd(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "cas"
            values_to_add = (cas(arguments, data_hash))
            values_to_add.each do |n|
                log_message.push(n)
            end
            return log_message
        elsif command == "exit"
            if arguments.length != 0
                log_message.push(error_message_error())
                return log_message
            else
                return true
            end
        end
    end
end

def get(list_of_keys, data_hash)
    its_valid = is_get_valid(list_of_keys)
    if its_valid == true
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
        result.push(message_end)
        return result
    end
    return its_valid
end

def gets(list_of_keys, data_hash)
    its_valid = is_gets_valid(list_of_keys)
    if its_valid == true
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
        result.push(message_end)
        return result
    end
    return its_valid
end

def set(arguments, data_hash)
    its_valid = is_set_valid(arguments)
    if its_valid == true
        data_hash[arguments[0]] = StoredKey.new(arguments[1], arguments[2], arguments[3], arguments[4])
        result = Array.new
        result.push(message_stored)
        return result
    end
    return its_valid
end

def add(arguments, data_hash)
    its_valid = is_add_valid(arguments)
    if its_valid == true
        result = Array.new
        if (data_hash[arguments[0]].nil? == true)
            data_hash[arguments[0]] = StoredKey.new(arguments[1], arguments[2], arguments[3], arguments[4])
            result.push(message_stored)
        else
            result.push(error_message_exists)
        end   
        return result
    end
    return its_valid
end

def replace(arguments, data_hash)
    its_valid = is_replace_valid(arguments)
    if its_valid == true
        result = Array.new
        if (data_hash[arguments[0]].nil? == false)
            data_hash[arguments[0]].value = arguments[4]
            data_hash[arguments[0]].flag = arguments[1]
            data_hash[arguments[0]].expiry = arguments[2]
            data_hash[arguments[0]].length = arguments[3]
            data_hash[arguments[0]].updateCreationTime
            data_hash[arguments[0]].update_cas
            result.push(message_stored)
        else
            result.push(error_message_not_found)
        end
        return result
    end
    return its_valid
end

def append(arguments, data_hash)
    its_valid = is_append_valid(arguments)
    if its_valid == true
        result = Array.new
        data_hash.each do |key,value|
            if (key == arguments[0])
                data_hash[arguments[0]].value = value.value + arguments[4]
                data_hash[arguments[0]].flag = arguments[1]
                data_hash[arguments[0]].expiry = arguments[2]
                data_hash[arguments[0]].length = data_hash[arguments[0]].length.to_i + arguments[3].to_i
                data_hash[arguments[0]].updateCreationTime
                data_hash[arguments[0]].update_cas
                result.push(message_stored)
                return result
            end
        end
        result.push(error_message_not_found)
        return result
    end
    return its_valid
end

def prependd(arguments, data_hash)
    its_valid = is_prepend_valid(arguments)
    if its_valid == true
        result = Array.new
        data_hash.each do |key,value|
            if (key == arguments[0])
                data_hash[arguments[0]].value = arguments[4] + value.value
                data_hash[arguments[0]].flag = arguments[1]
                data_hash[arguments[0]].length = data_hash[arguments[0]].length.to_i + arguments[3].to_i
                data_hash[arguments[0]].expiry = arguments[2]
                data_hash[arguments[0]].updateCreationTime
                data_hash[arguments[0]].update_cas
                result.push(message_stored)
                return result
            end
        end
        result.push(error_message_not_found)
        return result
    end
    return its_valid
end

def cas(arguments, data_hash)
    its_valid = is_cas_valid(arguments)
    if its_valid == true
        result = Array.new
        if (data_hash[arguments[0]].nil? == false)
            if (data_hash[arguments[0]].cas_number == arguments[4].to_i)
                data_hash[arguments[0]].value = arguments[5]
                data_hash[arguments[0]].update_cas
                result.push(message_stored)
            else
                result.push(error_message_exists)
            end
        else
            result.push(error_message_not_found)
        end
        return result
    end
    return its_valid
end



