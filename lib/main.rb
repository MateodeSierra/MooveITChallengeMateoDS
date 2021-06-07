require_relative 'collector'
require_relative 'constants'
require_relative 'server'
require_relative 'storage'
require_relative 'validation'
require_relative 'stored_key'
require_relative 'message_codes'
require_relative 'handler'
require 'socket'
require 'time'
require 'Monitor'

STORAGE = Storage.new
lock = Monitor.new
collector = Collector.new(COLLECTOR_INTERVAL,lock)
collector.every_n_seconds()
server = Server.new(SERVER_PORT, lock)
server.start_server
server.start_listening


