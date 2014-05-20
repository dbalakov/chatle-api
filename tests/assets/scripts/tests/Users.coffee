module 'Users'

test 'Constructor', ->
  throws (-> new ChatleClient.Users), 'Constructor without ChatleClient throw exception'
  throws (-> new ChatleClient.Users null), 'Call constructor with (client=null) throw exception'
  key = 'key'
  client = new ChatleClient key
  users = new ChatleClient.Users client

  equal users.client, client, 'See valid client'

  client.deactivate()

test 'me', ->
  callback = ->
  users = createUsers 'key'

  users.me callback

  ok users.client.transport.get.calledWith '/api/users/me', null, callback

test 'info', ->
  { id, callback } = { id : 'user_id', callback : -> }
  users = createUsers 'key'

  users.info id, callback

  ok users.client.transport.get.calledWith '/api/users/user_id', null, callback

test 'update', ->
  { first_name, last_name, display_name, callback } = { first_name : 'f_name', last_name : 'l_name', display_name : 'd_name', callback : -> }
  users = createUsers 'key'

  users.update first_name, last_name, display_name, callback

  ok users.client.transport.post.calledWith '/api/users/me', { first_name : 'f_name', last_name : 'l_name', display_name : 'd_name' }, callback

createUsers = (key)->
  client = new ChatleClient key
  client.transport.get = sinon.spy()
  client.transport.post = sinon.spy()
  client.transport.put = sinon.spy()
  client.transport.delete = sinon.spy()
  client.deactivate()

  new ChatleClient.Users client