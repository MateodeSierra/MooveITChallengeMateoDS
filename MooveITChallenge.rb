require 'socket'
require 'time'

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

end

#methods

def isExpired(key)
    current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    if ((key.creation_time + key.expiry) >= current_time)
        return false
    end
    return true
end

def valueGetter(key, client)
    client.print("VALUE ")
    client.print(key + " ")
    client.print(HASH_DATA[key].flag + " ")
    client.puts(HASH_DATA[key].length + "\r")
    client.puts(HASH_DATA[key].value)
end

def valueGetterCas(key, client)
    client.print("VALUE ")
    client.print(key + " ")
    client.print(HASH_DATA[key].flag + " ")
    client.print(HASH_DATA[key].length + " ")
    client.puts(HASH_DATA[key].cas_number.to_s + "\r")
    client.puts(HASH_DATA[key].value)
    
end


def get(list1, hash1, client)
    #recibe una o mas keys y devuelve todo lo encontrado
    #tiene que recibir un array de keys, y tener un foreach del array y buscar las keys, agregandolas a otro array
    list1.each do |n|
        valueGetter(hash1[n], client)
    end
    return
end

def gets(list1, hash1, client)
    #alternativa a get, devuelve el numero cas ademas del value el flag y el largo
    list1.each do |n|
        valueGetterCas(hash1[n], client)
    end
    return
end

def set(key, value, hash1)
    hash1[key] = value
end

def add(key, value, dir)
    #crea un nuevo key en el diccionario solo si no exisitia otro, si ya exisitia otro igual lo adelanta
    #busca si existe el key, si devuelve null lo guarda
end

def replace()
    #solo agrega key si ya existe en el diccionario
    #busca si existe el key, si existe lo replacea
end

def append()
    #agrega data al final de la data guardada, no se pasa del limite de caracteres
end

def prepend()
    #lo mismo que append pero antes de la data existente
end

def cas()
    #check and set, guarda data, pero solo si fuiste vos el ultimo que la updateo desde que vos la leiste 
end

HASH_DATA = {}

SERVER_PORT = 2452
server = TCPServer.new('localhost', SERVER_PORT)
#necesito crear el array o diccionario a donde van a ir los datos

puts("MooveIT Challenge, by Mateo de Sierra")
puts("Server is online, litening on port #{SERVER_PORT}")
puts("To take down the server press CTRL + C")

loop do
  client = server.accept
  client.puts("You have connected to the this Memcached server via port #{SERVER_PORT}." \
  "Please enter one of the implemented commands, if you enter " \
  "one of the associated numbers an example on how to use it will be printed\r")

  client.puts("Available commands:\r")
  client.puts("1. get\r")
  client.puts("2. gets\r")
  client.puts("3. set\r")
  client.puts("4. add\r")
  client.puts("5. replace\r")
  client.puts("6. append\r")
  client.puts("7. prepend\r")
  client.puts("8. cas\r")
  client.puts("9. Exit client\r")
  client.puts("Your choice: \r")

  loop do
    name = client.gets.chomp
    list1 = name.split(" ")
    value = client.gets.chomp
    clase1 = StoredKey.new(list1[2],list1[3].to_i,list1[4],value)
    set(list1[1], clase1, HASH_DATA)
    client.puts(HASH_DATA["foo"].value + "\r")
    client.puts(valueGetterCas("foo", client))

    sleep(5)

  end

end
