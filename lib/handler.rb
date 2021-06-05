require_relative 'stored_key'
require_relative 'validation'
require_relative 'message_codes'
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


def handle_command(client_command, data_hash)
    command = client_command[0]
    arguments = client_command[1..-1]
    if COMMANDS.include?(command)
        if command == "get"
            return get(arguments, data_hash)
        elsif command == "gets"
            return gets(arguments, data_hash)
        elsif command == "set"
            return set(arguments, data_hash)
        elsif command == "add"
            return add(arguments, data_hash)
        elsif command == "replace"
            return replace(arguments, data_hash)
        elsif command == "append"
            return append(arguments, data_hash)
        elsif command == "prepend"
            return prependd(arguments, data_hash)
        elsif command == "cas"
            return cas(arguments, data_hash)
        elsif command == "exit"
            if arguments.length != 0
                return error_message_error()
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
