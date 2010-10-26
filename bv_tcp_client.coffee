net = require 'net'
count = 0

stream = net.createConnection 8128, '127.0.0.1'

stream.on 'connect', ->
  console.log 'conneced!'
  setInterval update, 500

update = ->
  console.log count
  if stream?
    stream.write '<xml><user>' + count + '</user><action>' + 'addBomb' + '</action><x>10</x><y>20</y></xml>'
  count++
