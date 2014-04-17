module 'ChatleClient'

test 'Constructor without arguments', ->
  throws (-> client = new ChatleClient), 'Constructor without key throw exception'

test 'Constructor with key only', ->
  client = new ChatleClient 'key'
  equal client.key, 'key', 'See valid key'
  equal client.host, ChatleClient.DEFAULT_HOST, 'See valid host'
  ok client.transport instanceof ChatleClient.Transport, 'See valid transport'

test 'Constructor with key and host', ->
  client = new ChatleClient 'key', 'another host'
  equal client.key, 'key', 'See valid key'
  equal client.host, 'another host', 'See valid host'
  ok client.transport instanceof ChatleClient.Transport, 'See valid transport'

test 'Full constructor', ->
  client = new ChatleClient 'key', 'another host', 'transport'
  equal client.key, 'key', 'See valid key'
  equal client.host, 'another host', 'See valid host'
  equal client.transport, 'transport', 'See valid transport'

test 'Auth', ->
  client = new ChatleClient 'key'
  ok client.auth instanceof ChatleClient.Auth, 'auth instanceof ChatleClient.Auth'
