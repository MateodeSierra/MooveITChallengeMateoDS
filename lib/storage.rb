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

    def get(key)
        return @storage[key]
    end

    def set(key, flag, expiry, length, value)
        @storage[key] = StoredKey.new(flag, expiry, length, value)
    end

    def replace(key, flag, expiry, length, value)
        @storage.delete(key)
        @storage.push(StoredKey.new(flag, expiry, length, value))
    end

    def append(key, flag, expiry, length, value)
        old_value = @storage[key].value
        @storage.delete(key)
        new_key = StoredKey.new(flag, expiry, length, value)
        @storage.push(new_key)
        new_key.value = old_value + new_key.value
    end

    def prepend(key, flag, expiry, length, value)
        old_value = @storage[key].value
        @storage.delete(key)
        new_key = StoredKey.new(flag, expiry, length, value)
        @storage.push(new_key)
        new_key.value = new_key.value + old_value
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
