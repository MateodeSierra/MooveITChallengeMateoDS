require_relative '..\lib\collector'
require_relative '..\lib\constants'
require_relative '..\lib\storage'
require_relative '..\lib\validation'
require_relative '..\lib\stored_key'
require_relative '..\lib\message_codes'
require_relative '..\lib\handler'
require_relative '..\lib\server'

key = ""
value = ""
flag = ""
expiry = ""
length = ""

STORAGE = Storage.new
arguments = []

describe set(arguments, STORAGE.get_hash) do

   #set with valid arguments
   it 'creates a key value pair on the hash with valid arguments' do
      arguments = Array["foo", "0", "3600","3", "bar"]
      expect(set(arguments, STORAGE.get_hash)).to eq(["STORED\r\n"])
      expect(get(Array["foo"],STORAGE.get_hash)).to eq(["VALUE foo 0 3\r\n", "bar\r\n", "END\r\n"])
   end
   
   #set with invalid arguments
   it 'tries to create a key value pair on the hash with invalid arguments' do
      arguments = Array["foo", "0t", "36s200","3", "bar"]
      expect(set(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end 

   #set with invalid number of arguments
   it 'tries to create a key value pair on the hash with invalid number of arguments' do
      arguments = Array["foo", "0t","3", "bar"]
      expect(set(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

end

describe get(arguments, STORAGE.get_hash) do

   #get with valid arguments
   it 'tries to get back a value with the correct arguments' do
      expect(get(Array["foo"],STORAGE.get_hash)).to eq(["VALUE foo 0 3\r\n", "bar\r\n", "END\r\n"])
   end

   #get with invalid keys
   it 'tries to get back the value of an unexistant key' do
      expect(get(Array["fob"],STORAGE.get_hash)).to eq(["NOT_FOUND\r\n", "END\r\n"])
   end

   #get with a key that doenst expire
   it 'tries to get back the value of a key that doesnt expire' do
      STORAGE.get_hash["foo"].expiry = 0
      expect(get(Array["foo"],STORAGE.get_hash)).to eq(["VALUE foo 0 3\r\n", "bar\r\n", "END\r\n"])
   end

   #get with one key that exists and one that doesnt
   it 'tries to get back the value of 2 keys, one which exists and the other that doesnt' do
      set(Array["mat", "0", "3600","2", "eo"],STORAGE.get_hash)
      expect(get(Array["foo", "mate"],STORAGE.get_hash)).to eq(["VALUE foo 0 3\r\n", "bar\r\n","NOT_FOUND\r\n", "END\r\n"])
   end

end

describe gets(arguments, STORAGE.get_hash) do

   #get with valid arguments
   it 'tries to get back a value with the correct arguments' do
      expect(gets(Array["foo"],STORAGE.get_hash)).to eq(["VALUE foo 0 3 1\r\n", "bar\r\n", "END\r\n"])
   end
   
   #get with invalid keys
   it 'tries to get back the value of un unexistant key' do
      expect(gets(Array["fo3"],STORAGE.get_hash)).to eq(["NOT_FOUND\r\n", "END\r\n"])
   end

   #gets with a key that doenst expire
   it 'tries to gets back the value of a key that doesnt expire' do
      STORAGE.get_hash["foo"].expiry = 0
      expect(gets(Array["foo"],STORAGE.get_hash)).to eq(["VALUE foo 0 3 1\r\n", "bar\r\n", "END\r\n"])
   end

   #get with one key that exists and one that doenst
   it 'tries to get back the value of 2 keys, one which exists and the other that doesnt' do
      expect(gets(Array["foo", "mate"],STORAGE.get_hash)).to eq(["VALUE foo 0 3 1\r\n", "bar\r\n","NOT_FOUND\r\n", "END\r\n"])
   end
   
end

describe add(arguments, STORAGE.get_hash) do

   #add with valid arguments
   it 'tries to add a new StoredKey with the correct arguments' do
      arguments = Array["pet", "0", "3600","3", "tou"]
      expect(add(arguments, STORAGE.get_hash)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],STORAGE.get_hash)).to eq(["VALUE pet 0 3\r\n", "tou\r\n", "END\r\n"])
   end

   #add with invalid arguments
   it 'tries to add a new StoredKey with incorrect argument values' do
      arguments = Array["ket", "0t", "36s200","3", "ton"]
      expect(set(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

   #add already created key
   it 'tries to add a new StoredKey with a key that already exists' do
      arguments = Array["pet", "0", "3600","3", "tou"]
      expect(add(arguments, STORAGE.get_hash)).to eq(["EXISTS\r\n"])
   end

   #add with invalid number of arguments
   it 'tries to add a new StoredKey with an incorrect number of arguments' do
      arguments = Array["ket", "0", "36200","3", "ton", "hello"]
      expect(set(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

end

describe replace(arguments, STORAGE.get_hash) do

   #replace with valid arguments
   it 'tries to replace a StoredKey with the correct arguments' do
      arguments = Array["pet", "0", "3600","3", "cro"]
      expect(replace(arguments, STORAGE.get_hash)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],STORAGE.get_hash)).to eq(["VALUE pet 0 3\r\n", "cro\r\n", "END\r\n"])
   end

   #replace with invalid arguments
   it 'tries to replace a StoredKey with incorrect argument values' do
      arguments = Array["pet", "0", "3602cs0","3s", "tou"]
      expect(replace(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

   #replace a key that does not exist
   it 'tries to replace a StoredKey with a key that doesnt exist' do
      arguments = Array["ket", "0", "3600","3", "ooo"]
      expect(replace(arguments, STORAGE.get_hash)).to eq(["NOT_FOUND\r\n"])
   end

   #replace with invalid number of arguments
   it 'tries to replace a StoredKey with an incorrect number of arguments' do
      arguments = Array["pet", "0", "3600","3", "cro", "2"]
      expect(replace(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end
   
end

describe append(arguments, STORAGE.get_hash) do

   #append with valid arguments
   it 'tries to append data to the value of a key with the correct number of arguments' do
      arguments = Array["pet", "0", "3600","3", "mat"]
      expect(append(arguments, STORAGE.get_hash)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],STORAGE.get_hash)).to eq(["VALUE pet 0 6\r\n", "cromat\r\n", "END\r\n"])
   end

   #append with invalid arguments
   it 'tries to append data to the value of a key with incorrect argument values' do
      arguments = Array["pet", "0", "36s00","3", "mat"]
      expect(append(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

   #append with invalid number of arguments
   it 'tries to append data to the value of a key with an incorrect number of arguments' do
      arguments = Array["pet", "0", "36s00","3", "mat", "2"]
      expect(append(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end
   
end

describe prepend(arguments, STORAGE.get_hash) do

   #prepend with valid arguments
   it 'tries to prepend data to the value of a key with the correct number of arguments' do
      arguments = Array["pet", "0", "3600","3", "teo"]
      expect(prepend(arguments, STORAGE.get_hash)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],STORAGE.get_hash)).to eq(["VALUE pet 0 9\r\n", "teocromat\r\n", "END\r\n"])
   end

   #prepend with invalid arguments
   it 'tries to prepend data to the value of a key with incorrect argument values' do
      arguments = Array["pet", "0", "36s00","3", "mat"]
      expect(prepend(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

   #prepend with invalid number of arguments
   it 'tries to prepend data to the value of a key with an incorrect number of arguments' do
      arguments = Array["pet", "0", "36s00","3", "mat", "2"]
      expect(prepend(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end
      
end

describe cas(arguments, STORAGE.get_hash) do

   #cas with valid arguments
   it 'tries to change the value of a stored key with the correct arguments' do
      cas_number = gets(Array["foo"], STORAGE.get_hash)
      value = cas_number[0].split
      number = value[4]
      arguments = Array["foo", "0", "3600","3", number, "mat"]
      expect(cas(arguments, STORAGE.get_hash)).to eq(["STORED\r\n"])
   end

   #cas with invalid arguments
   it 'tries to change the value of a stored key with invalid argument values' do
      cas_number = gets(Array["foo"], STORAGE.get_hash)
      value = cas_number[0].split
      number = value[4]
      arguments = Array["foo", "0", "360t0","3", number, "cat"]
      expect(cas(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

   #cas with invalid number of arguments
   it 'tries to change the value of a stored key with an invalid number of arguments' do
      cas_number = gets(Array["foo"], STORAGE.get_hash)
      value = cas_number[0].split
      number = value[4]
      arguments = Array["foo", "0", "3600","3", number, "43", "cat"]
      expect(cas(arguments, STORAGE.get_hash)).to eq(["ERROR\r\n"])
   end

   #cas with outdated cas number
   it 'tries to change the value of a stored key with an outdated cas number' do
      cas_number = gets(Array["foo"], STORAGE.get_hash)
      value = cas_number[0].split
      number = value[4].to_i + 1
      arguments = Array["foo", "0", "3600","3", number, "mat"]
      expect(cas(arguments, STORAGE.get_hash)).to eq(["EXISTS\r\n"])
   end
      
end




   





