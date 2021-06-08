require_relative 'constants'
require_relative 'server'
require_relative 'storage'
require_relative 'validation'
require_relative 'stored_key'
require_relative 'message_codes'
require_relative 'handler'

class Collector

    def initialize(seconds, lock)
        @seconds = seconds
        @lock = lock
    end

    def seconds
        @seconds
    end

    def seconds=(seconds)
        @seconds = seconds
    end

    def clear_expired()
        STORAGE.get_hash.each do |key,value|
            if STORAGE.is_expired(key)
                STORAGE.get_hash.delete(key)
            end
        end
    end

    def every_n_seconds()
        thread = Thread.new do
            while true
                before = Time.now
                @lock.synchronize do
                    clear_expired()
                end
                interval = @seconds-(Time.now-before)
                sleep(interval) if interval > 0
            end
        end
        return thread
    end
end



