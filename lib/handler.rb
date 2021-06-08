require_relative 'collector'
require_relative 'constants'
require_relative 'server'
require_relative 'storage'
require_relative 'validation'
require_relative 'stored_key'
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

def handle_command(client_command, data_hash)
    command = client_command[0]
    arguments = client_command[1..-1]
    if COMMANDS.include?(command)
        if command == "get"
            return get_gets(arguments, false)
        elsif command == "gets"
            return get_gets(arguments, true)
        elsif command == "set"
            return set(arguments)
        elsif command == "add"
            return add(arguments)
        elsif command == "replace"
            return replace(arguments)
        elsif command == "append"
            return append(arguments)
        elsif command == "prepend"
            return prepend(arguments)
        elsif command == "cas"
            return cas(arguments)
        end
    end
end

#Shared command for get and gets, if it receives true as argument, it does gets, otherwise it does get.
def get_gets(list_of_keys, bool)
    if (is_get_valid(list_of_keys))
        result = Array.new
        values_to_add = Array.new
        list_of_keys.each do |n|
            if (STORAGE.theres_something(n))
                if (bool)
                    values_to_add = switch_get(n, true)
                    values_to_add.each do |m|
                        result.push(m)
                    end
                else
                    values_to_add = switch_get(n, false)
                    values_to_add.each do |m|
                        result.push(m)
                    end
                end
            else
                result.push(error_message_not_found)
            end
        end
    else
        result.push(error_message_error)
    end
    result.push(message_end)
    return result
end

def switch_get(key, bool)
    if (bool)
        return value_getter_cas(key)
    else
        return value_getter(key)
    end
end

# arguments[] format is (key, flag, expiry, length, value)
def set(arguments)
    result = Array.new
    if is_set_valid(arguments)
        STORAGE.set(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4])
        result.push(message_stored)
        return result
    else
        result.push(error_message_error)
        return result
    end
    return message_stored
end

# arguments[] format is (key, flag, expiry, length, value)
def add(arguments)
    if is_add_valid(arguments)
        result = Array.new
        if (STORAGE.theres_something(arguments[0]) == false)
            STORAGE.set(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4])
            result.push(message_stored)
        else
            result.push(error_message_exists)
        end   
        return result
    end
    return its_valid
end

# arguments[] format is (key, flag, expiry, length, value)
def replace(arguments)
    its_valid = is_replace_valid(arguments)
    if its_valid == true
        result = Array.new
        if (STORAGE.theres_something(arguments[0]))
            STORAGE.get_hash[arguments[0]].value = arguments[4]
            update_key_data(arguments[0], arguments[1], arguments[2], arguments[3], true)
            result.push(message_stored)
        else
            result.push(error_message_not_found)
        end
        return result
    end
    return its_valid
end

# arguments[] format is (key, flag, expiry, length, value)
def append(arguments)
    its_valid = is_append_valid(arguments)
    if its_valid == true
        result = Array.new
        STORAGE.get_hash.each do |key,value|
            if (STORAGE.theres_something(key))
                if (key == arguments[0])
                    STORAGE.get(arguments[0]).value = value.value + arguments[4]
                    update_key_data(arguments[0], arguments[1], arguments[2], arguments[3], false)
                    result.push(message_stored)
                    return result
                end
            end
        end
        result.push(error_message_not_found)
        return result
    end
    return its_valid
end

# arguments[] format is (key, flag, expiry, length, value)
def prepend(arguments)
    its_valid = is_prepend_valid(arguments)
    if its_valid == true
        result = Array.new
        STORAGE.get_hash.each do |key,value|
            if (STORAGE.theres_something(key))
                if (key == arguments[0])
                    STORAGE.get(arguments[0]).value = arguments[4] + value.value
                    update_key_data(arguments[0], arguments[1], arguments[2], arguments[3], false)
                    result.push(message_stored)
                    return result
                end
            end
        end
        result.push(error_message_not_found)
        return result
    end
    return its_valid
end

# arguments[] format is (key, flag, expiry, length, value)
def cas(arguments)
    its_valid = is_cas_valid(arguments)
    if its_valid == true
        result = Array.new
        if (STORAGE.theres_something(arguments[0]))
            if (STORAGE.get_hash[arguments[0]].cas_number == arguments[4].to_i)
                STORAGE.get_hash[arguments[0]].value = arguments[5]
                STORAGE.get_hash[arguments[0]].update_cas
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

def value_getter(key)
    result = Array.new
    if (STORAGE.is_expired(key) == false)
        result.push("VALUE " + key + " " + STORAGE.get(key).flag.to_s + " " + STORAGE.get(key).length.to_s + "\r\n")
        result.push(STORAGE.get(key).value + "\r\n")
    else
        result.push(error_message_not_found)
    end
    return result
end

def value_getter_cas(key)
    result = Array.new
    if (STORAGE.is_expired(key) == false)
        result.push("VALUE " + key + " " + STORAGE.get(key).flag.to_s + " " + STORAGE.get(key).length.to_s + " " + STORAGE.get(key).cas_number.to_s + "\r\n")
        result.push(STORAGE.get(key).value + "\r\n")
    else
        result.push(error_message_not_found)
    end
    return result
end

# Updates the key´s data, when bool is set to true, it replaces the length, when false it adds old length with the new one
def update_key_data(key ,flag, expiry, length, bool)
    STORAGE.get(key).flag = flag
    STORAGE.get(key).expiry = expiry
    if (bool)
        STORAGE.get(key).length = length
    else
        STORAGE.get(key).length = length.to_i + STORAGE.get(key).length.to_i
    end
    STORAGE.get(key).updateCreationTime
    STORAGE.get(key).update_cas
end
