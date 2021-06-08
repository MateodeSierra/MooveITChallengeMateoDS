require_relative 'collector'
require_relative 'constants'
require_relative 'server'
require_relative 'storage'
require_relative 'stored_key'
require_relative 'message_codes'
require_relative 'handler'


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

def is_get_valid(arguments)
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
        return false
    elsif (arguments.length != 5)
        log_message.push(error_message_error())
        return false
    elsif (correct_length(arguments[4], arguments[3]) == false)
        log_message.push(error_message_error())
        return false
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