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
