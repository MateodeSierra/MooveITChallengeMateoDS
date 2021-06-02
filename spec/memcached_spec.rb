require_relative '..\lib\memcached'
require_relative '..\lib\stored_key'

key = ""
value = ""
flag = ""
expiry = ""
length = ""


arguments = []

describe set(arguments, HASH_DATA) do

   #set with valid arguments
   it 'creates a key value pair on the hash with valid arguments' do
      arguments = Array["foo", "0", "3600","3", "bar"]
      expect(set(arguments, HASH_DATA)).to eq(["STORED\r\n"])
      expect(get(Array["foo"],HASH_DATA)).to eq(["VALUE foo 0 3\r\n", "bar\r\n", "END\r\n"])
   end
   
   #set with invalid arguments
   it 'tries to create a key value pair on the hash with invalid arguments' do
      arguments = Array["foo", "0t", "36s200","3", "bar"]
      expect(set(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end 

   #set with invalid number of arguments
   it 'tries to create a key value pair on the hash with invalid number of arguments' do
      arguments = Array["foo", "0t","3", "bar"]
      expect(set(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

end

describe get(arguments, HASH_DATA) do

   #get with valid arguments
   it 'tries to get back a value with the correct arguments' do
      expect(get(Array["foo"],HASH_DATA)).to eq(["VALUE foo 0 3\r\n", "bar\r\n", "END\r\n"])
   end

   #get with invalid keys
   it 'tries to get back the value of un unexistant key' do
      expect(get(Array["fob"],HASH_DATA)).to eq(["NOT_FOUND\r\n", "END\r\n"])
   end

   #get with one key that exists and one that doenst
   it 'tries to get back the value of 2 keys, one which exists and the other that doesnt' do
      set(Array["mat", "0", "3600","2", "eo"],HASH_DATA)
      expect(get(Array["foo", "mate"],HASH_DATA)).to eq(["VALUE foo 0 3\r\n", "bar\r\n","NOT_FOUND\r\n", "END\r\n"])
   end

end

describe gets(arguments, HASH_DATA) do

   #get with valid arguments
   it 'tries to get back a value with the correct arguments' do
      expect(gets(Array["foo"],HASH_DATA)).to eq(["VALUE foo 0 3 1\r\n", "bar\r\n", "END\r\n"])
   end
   
   #get with invalid keys
   it 'tries to get back the value of un unexistant key' do
      expect(gets(Array["fo3"],HASH_DATA)).to eq(["NOT_FOUND\r\n", "END\r\n"])
   end

   #get with one key that exists and one that doenst
   it 'tries to get back the value of 2 keys, one which exists and the other that doesnt' do
      expect(gets(Array["foo", "mate"],HASH_DATA)).to eq(["VALUE foo 0 3 1\r\n", "bar\r\n","NOT_FOUND\r\n", "END\r\n"])
   end
   
end

describe add(arguments, HASH_DATA) do

   #add with valid arguments
   it 'tries to add a new StoredKey with the correct arguments' do
      arguments = Array["pet", "0", "3600","3", "tou"]
      expect(add(arguments, HASH_DATA)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],HASH_DATA)).to eq(["VALUE pet 0 3\r\n", "tou\r\n", "END\r\n"])
   end

   #add with invalid arguments
   it 'tries to add a new StoredKey with incorrect argument values' do
      arguments = Array["ket", "0t", "36s200","3", "ton"]
      expect(set(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

   #add already created key
   it 'tries to add a new StoredKey with incorrect argument values' do
      arguments = Array["pet", "0", "3600","3", "tou"]
      expect(add(arguments, HASH_DATA)).to eq(["EXISTS\r\n"])
   end

   #add with invalid number of arguments
   it 'tries to add a new StoredKey with an incorrect number of arguments' do
      arguments = Array["ket", "0", "36200","3", "ton", "hello"]
      expect(set(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

end

describe replace(arguments, HASH_DATA) do

   #replace with valid arguments
   it 'tries to replace a StoredKey with the correct arguments' do
      arguments = Array["pet", "0", "3600","3", "cro"]
      expect(replace(arguments, HASH_DATA)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],HASH_DATA)).to eq(["VALUE pet 0 3\r\n", "cro\r\n", "END\r\n"])
   end

   #replace with invalid arguments
   it 'tries to replace a StoredKey with incorrect argument values' do
      arguments = Array["pet", "0", "3602cs0","3s", "tou"]
      expect(replace(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

   #replace a key that does not exist
   it 'tries to replace a StoredKey with incorrect argument values' do
      arguments = Array["ket", "0", "3600","3", "ooo"]
      expect(replace(arguments, HASH_DATA)).to eq(["NOT_FOUND\r\n"])
   end

   #replace with invalid number of arguments
   it 'tries to replace a StoredKey with an incorrect number of arguments' do
      arguments = Array["pet", "0", "3600","3", "cro", "2"]
      expect(replace(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end
   
end

describe append(arguments, HASH_DATA) do

   #append with valid arguments
   it 'tries to append data to the value of a key with the correct number of arguments' do
      arguments = Array["pet", "0", "3600","3", "mat"]
      expect(append(arguments, HASH_DATA)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],HASH_DATA)).to eq(["VALUE pet 0 6\r\n", "cromat\r\n", "END\r\n"])
   end

   #append with invalid arguments
   it 'tries to append data to the value of a key with incorrect argument values' do
      arguments = Array["pet", "0", "36s00","3", "mat"]
      expect(append(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

   #append with invalid number of arguments
   it 'tries to append data to the value of a key with an incorrect number of arguments' do
      arguments = Array["pet", "0", "36s00","3", "mat", "2"]
      expect(append(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end
   
end

describe prependd(arguments, HASH_DATA) do

   #prepend with valid arguments
   it 'tries to append data to the value of a key with the correct number of arguments' do
      arguments = Array["pet", "0", "3600","3", "teo"]
      expect(prependd(arguments, HASH_DATA)).to eq(["STORED\r\n"])
      expect(get(Array["pet"],HASH_DATA)).to eq(["VALUE pet 0 9\r\n", "teocromat\r\n", "END\r\n"])
   end

   #prepend with invalid arguments
   it 'tries to append data to the value of a key with incorrect argument values' do
      arguments = Array["pet", "0", "36s00","3", "mat"]
      expect(prependd(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

   #prepend with invalid number of arguments
   it 'tries to append data to the value of a key with an incorrect number of arguments' do
      arguments = Array["pet", "0", "36s00","3", "mat", "2"]
      expect(prependd(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end
      
end

describe cas(arguments, HASH_DATA) do

   #cas with valid arguments
   it 'tries to change the value of a stored key with the correct arguments' do
      cas_number = gets(Array["foo"], HASH_DATA)
      value = cas_number[0].split
      number = value[4]
      arguments = Array["foo", "0", "3600","3", number, "mat"]
      expect(cas(arguments, HASH_DATA)).to eq(["STORED\r\n"])
   end

   #cas with invalid arguments
   it 'tries to change the value of a stored key with invalid argument values' do
      cas_number = gets(Array["foo"], HASH_DATA)
      value = cas_number[0].split
      number = value[4]
      arguments = Array["foo", "0", "360t0","3", number, "cat"]
      expect(cas(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

   #cas with invalid number of arguments
   it 'tries to change the value of a stored key with an invalid number of arguments' do
      cas_number = gets(Array["foo"], HASH_DATA)
      value = cas_number[0].split
      number = value[4]
      arguments = Array["foo", "0", "3600","3", number, "43", "cat"]
      expect(cas(arguments, HASH_DATA)).to eq(["ERROR\r\n"])
   end

   #cas with outdated cas number
   it 'tries to change the value of a stored key with an outdated cas number' do
      cas_number = gets(Array["foo"], HASH_DATA)
      value = cas_number[0].split
      number = value[4].to_i + 1
      arguments = Array["foo", "0", "3600","3", number, "mat"]
      expect(cas(arguments, HASH_DATA)).to eq(["EXISTS\r\n"])
   end
      
end




   





