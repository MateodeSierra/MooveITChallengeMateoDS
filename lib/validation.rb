
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

def correct_length(value, supposed_length)
    if (value.length == supposed_length.to_i)
        return true
    end
    return false
end


##########################################
def is_expired(key)
    current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    if (HASH_DATA[key].expiry.to_i == 0)
        return false
    elsif ((HASH_DATA[key].creation_time.to_i + HASH_DATA[key].expiry.to_i) >= current_time)
        return false
    end
    HASH_DATA.delete(key)
    return true
end


##########################################
def theres_something(key)
    if (HASH_DATA[key].nil?)
        return false
    elsif (is_expired(key))
        return false
    end
    return true
end

def is_get_valid(arguments)
    log_message = Array.new
    if (arguments.length < 1)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end

def is_gets_valid(arguments)
    log_message = Array.new
    if (arguments.length < 1)
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
    elsif (arguments.length != 5)
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
    elsif (arguments.length != 5)
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
    elsif (arguments.length != 5)
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
    elsif (arguments.length != 5)
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
    elsif (arguments.length != 5)
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
    elsif (arguments.length != 6)
        log_message.push(error_message_error())
        return log_message
    elsif (correct_length(arguments[5], arguments[3]) == false)
        log_message.push(error_message_error())
        return log_message
    end
    return true
end