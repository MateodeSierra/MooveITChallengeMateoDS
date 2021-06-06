require_relative 'storage'
require_relative 'stored_key'
require_relative 'validation'

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
        HASH_DATA.each do |key,value|
            if is_expired(key)
                HASH_DATA.delete(key)
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



