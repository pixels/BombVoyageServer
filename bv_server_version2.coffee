#!~/.nodejs/bin/coffee

http = require 'http'
xml = require './Lib/bv_xml'
net = require 'net'
sys = require 'sys'
xml2js = require 'xml2js'
querystring = require 'querystring'

map_width = 200
map_height = 300

list = []

accounts =
  0:
    name: "karatsu@pixels.jp"
    id: 1
    pass: "pixels"
  1:
    name: "ishizu@pixels.jp"
    id: 2
    pass: "pixels"
  2:
    name: "kikkawa@pixels.jp"
    id: 3
    pass: "pixels"
  3:
    name: "oshima@pixels.jp"
    id: 4
    pass: "pixels"
  4:
    name: "yamada@pixels.jp"
    id: 5
    pass: "pixels"

objs = {}
objs.bombs = {}

parser = new xml2js.Parser()

###--- main ---###
setInterval update, 100

http_server = http.createServer (req, res) ->
  console.log "ip : " + req.connection.remoteAddress
  post_handler req, (request_data) ->
    if request_data.action? and request_data.action is 'login'
      responseToLogin res, request_data
http_server.listen 8125
console.log 'Server running at http://127.0.0.1:8124/'

tcp_server = net.createServer (stream) ->
  stream.setEncoding 'utf8'

  stream.on 'connect', ->
    stream.write 'connected\r\n'
    addStream stream

  stream.on 'data', (data) ->
    txt = data
    console.log txt
    parser.parseString txt
    broardCast stream, 'res: ' + txt + '\n'
    stream.write 'res: ' + txt + '\n'

  stream.on 'end', ->
    console.log 'disconnected'
    removeStream stream
    stream.end

tcp_server.listen 8128

parser.addListener 'end', (result) ->
  #console.log sys.inspect(result)
  console.log result.user
  console.log result.action
  console.log result.x
  console.log result.y
  console.log 'Done.'

### -- functions -- ###

responseToLogin = (res, request_data) ->
  console.log "receive login request"
  res.writeHead 200, {'Content-Type': 'text/plain'}
  console.log request_data.name + " , " + request_data.pass

  flag = false
  for i in [0..4]
    if accounts[i] and accounts[i].name is request_data.name and accounts[i].pass is request_data.pass
      res.end xml.getResponseForLogin true, "ログインに成功しました．"
      flag = true
      break
  if flag then res.end xml.getResponseForLogin false, "ログインに失敗しました．メールアドレスかパスワードに誤りがあるようです．"

update = ->
###
  for (var i = 0; i < requests.length; i++) {
    counters[i]++;
    if (counters[i] > 10) {
      res = responders[i];
      removeRequest(i);
      sayHello(res);
    }
  }
}
###

post_handler = (request, callback) ->
  _REQUEST = {}
  _CONTENT = ''

  if request.method is 'POST'
    console.log 'POST REQUEST'
    request.addListener 'data', (chunk) ->
      _CONTENT += chunk

    request.addListener 'end', ->
      _REQUEST = querystring.parse _CONTENT
      console.log _REQUEST
      callback _REQUEST

addStream = (stream) ->
  console.log('add')
  list.push stream

removeStream = (stream) ->
  for i in [0..list.length-1]
    if list[i] is stream
      list.splice i, 1
      break

broardCast = (stream, txt) ->
  for i in [0..list.length-1]
    if list[i] isnt stream
      list[i].write txt

getTestXML = ->
  xml = '<?xml version="1.0" encoding="UTF8"?>
    <contents>
      <name>neo</name>
      <id>neo</id>
      <items>
	<bombs>
	  <id1>basic</id1>
	    <id2>remote</id2>
	</bombs>
	<ox>1</ox>
      </items>
    </contents>'
