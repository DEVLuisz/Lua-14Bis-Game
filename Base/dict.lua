UltimaCopa = {
    ano = 2022,
    sede = 'Qatar',
    jogadores = {
      'Alisson',
      'Richarlison',
      'Vinícius Júnior',
      'Raphinha',
      'Antony',
      'Pedro',
      'Daniel Alves',
      'Lucas Paquetá',
      'Gabriel Jesus',
      'Gabriel Martinelli',
      'Thiago'
    },
    imprime = function (self)
      for key, value in ipairs(self.jogadores) do
      print(key, value)
      end
    end
}

print(UltimaCopa['ano'])
print(UltimaCopa.ano)

UltimaCopa.capitao =  'Neymar'
print(UltimaCopa.capitao)

print(UltimaCopa.jogadores[1])
print(UltimaCopa.jogadores[2])

table.insert(UltimaCopa.jogadores, 'Neymar')
table.insert(UltimaCopa.jogadores, 'Pelé')
table.remove(UltimaCopa.jogadores, 13)

UltimaCopa.imprime(UltimaCopa)
-- Quando passamos uma função recebendo ela mesma(self), podemos fazer dessa forma:
UltimaCopa:imprime()