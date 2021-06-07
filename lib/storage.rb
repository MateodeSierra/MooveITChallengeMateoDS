require_relative 'collector'
require_relative 'constants'
require_relative 'server'
require_relative 'validation'
require_relative 'stored_key'
require_relative 'message_codes'
require_relative 'handler'

class Storage

    def initialize()
        @storage = {}
    end

    def get_hash
        @storage
    end

    def value_getter(key)
        result = Array.new
        if (is_expired(key) == false)
            result.push("VALUE " + key + " " + @storage[key].flag.to_s + " " + @storage[key].length.to_s + "\r\n")
            result.push(@storage[key].value + "\r\n")
        else
            result.push(error_message_not_found)
        end
        return result
    end

    def value_getter_cas(key)
        result = Array.new
        if (is_expired(key) == false)
            result.push("VALUE " + key + " " + @storage[key].flag.to_s + " " + @storage[key].length.to_s + " " + @storage[key].cas_number.to_s + "\r\n")
            result.push(@storage[key].value + "\r\n")
        else
            result.push(error_message_not_found)
        end
        return result
    end

    def is_expired(key)
        current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        if (@storage[key].expiry.to_i == 0)
            return false
        elsif ((@storage[key].creation_time.to_i + @storage[key].expiry.to_i) >= current_time)
            return false
        end
        @storage.delete(key)
        return true
    end

    def theres_something(key)
        if (@storage[key].nil?)
            return false
        elsif (is_expired(key))
            return false
        end
        return true
    end
end
