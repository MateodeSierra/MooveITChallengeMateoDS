class StoredKey
    @@next_cas_number = 0

    def initialize(flag, expiry, length, value)
        @length = length
        @expiry = expiry
        @value = value
        @flag = flag
        @creation_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @cas_number = @@next_cas_number + 1
        @@next_cas_number += 1
    end

    def length
        @length
    end

    def expiry
        @expiry
    end

    def value
        @value
    end

    def creation_time
        @creation_time
    end

    def flag
        @flag
    end

    def cas_number
        @cas_number
    end

    def flag=(flag)
        @flag = flag
    end

    def length=(length)
        @length = length
    end

    def value=(value)
        @value = value
    end

    def  expiry=(expiry)
        @expiry = expiry
    end

    def updateCreationTime
        @creation_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def update_cas
        @cas_number = @@next_cas_number + 1
        @@next_cas_number += 1
    end

end