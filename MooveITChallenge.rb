require 'socket'

#methods

def get(number1, number2, dic1)
    #recibe una o mas keys y devuelve todo lo encontrado
end

def gets()
    #alternativa a get, devuelve el numero cas ademas del value el flag y el largo
end

def set(key, value, dir)
    #crea la key en el diccionario, los items nuevos estan arriba en el LRU
end

def add(key, value, dir)
    #crea un nuevo key en el diccionario solo si no exisitia otro, si ya exisitia otro igual lo adelanta
end

def replace()
    #solo agrega key si ya existe en el diccionario
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
  client.puts("Your choice: \r")
  name = gets
  client.close
end
