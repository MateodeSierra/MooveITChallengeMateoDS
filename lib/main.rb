require_relative 'handler'
require_relative 'collector'
require_relative 'constants'
require_relative 'server'
require 'socket'
require 'time'
require 'Monitor'

lock = Monitor.new
collector = Collector.new(COLLECTOR_INTERVAL,lock)
collector.every_n_seconds()
server = Server.new(SERVER_PORT, lock)
server.start_server
server.start_listening


