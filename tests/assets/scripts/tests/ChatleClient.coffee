module 'ChatleClient'

test 'Constructor without arguments', ->
  throws (-> client = new ChatleClient), 'Constructor without key throw exception'

test 'Constructor with key only', ->
  client = new ChatleClient 'key'

  equal client.key, 'key', 'See valid key'
  equal client.host, ChatleClient.DEFAULT_HOST, 'See valid host'
  ok client.transport instanceof ChatleClient.Transport, 'See valid transport'

  client.deactivate()

test 'Constructor with key and host', ->
  client = new ChatleClient 'key', 'https://chatle.co/system/widgets/_out/api.html#{}'

  equal client.key, 'key', 'See valid key'
  equal client.host, 'https://chatle.co/system/widgets/_out/api.html#{}', 'See valid host'
  ok client.transport instanceof ChatleClient.Transport, 'See valid transport'

  client.deactivate()

test 'Full constructor', ->
  client = new ChatleClient 'key', 'another host', 'transport'

  equal client.key, 'key', 'See valid key'
  equal client.host, 'another host', 'See valid host'
  equal client.transport, 'transport', 'See valid transport'

test 'setAuthToken', ->
  client = new ChatleClient 'key'

  client.setAuthToken 'client auth token'

  equal client.transport.authToken, 'client auth token', 'Transport auth token'

  client.deactivate()

test 'deactivate', ->
  client = new ChatleClient 'key'
  deactivate = client.transport.deactivate
  client.transport.deactivate = sinon.spy()

  client.deactivate()

  ok client.transport.deactivate.calledOnce, 'Transport deactivate'

  client.transport.deactivate = deactivate
  client.deactivate()

test 'Models', ->
  client = new ChatleClient 'key'

  ok client.auth instanceof ChatleClient.Auth, 'auth instanceof ChatleClient.Auth'
  ok client.rooms instanceof ChatleClient.Rooms, 'rooms instanceof ChatleClient.Rooms'
  ok client.users instanceof ChatleClient.Users, 'users instanceof ChatleClient.Rooms'

  client.deactivate()
