require_relative '..\lib\memcached'
require_relative '..\lib\stored_key'

HASH_DATA = {}
key = ""
value = ""
flag = ""
expiry = ""
length = ""


client_command = []

describe set(key, value, flag, expiry, length, HASH_DATA) do

   #set with valid arguments
   it 'creates a key value pair on the hash with valid arguments' do
      client_command = Array["set", "foo", "0", "3600","3", "bar"]
      expect(handle_command(client_command, HASH_DATA)).to eq(["STORED\r\n"])
   end
   
   #set with invalid arguments
   it 'tries to create a key value pair on the hash with invalid arguments' do
      client_command = Array["set", "foo", "0t", "36s200","3", "bar"]
      expect(handle_command(client_command, HASH_DATA)).to eq(["ERROR\r\n"])
   end 

   #set with invalid number of arguments
   it 'tries to create a key value pair on the hash with invalid number of arguments' do
      client_command = Array["set", "foo", "0t","3", "bar"]
      expect(handle_command(client_command, HASH_DATA)).to eq(["ERROR\r\n"])
   end

end




   





