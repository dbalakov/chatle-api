module 'Auth'

test 'Constructor', ->
  throws (-> new ChatleClient.Auth), 'Constructor without ChatleClient throw exception'
  throws (-> new ChatleClient.Auth null), 'Call constructor with (client=null) throw exception'
  key = 'key'
  client = new ChatleClient key
  auth = new ChatleClient.Auth client
  equal auth.client, client, 'See valid client'

test 'registerMobile', ->
  { key, number, callback } = { key : 'key', number : 'number', callback : -> }
  auth = createAuth key

  auth.registerMobile number, callback

  ok auth.client.transport.get.calledWith '/api/auth/register_mobile', { number : 'number' }, callback

test 'confirmCode', ->
  { key, confirmation_id, code, display_name, callback } = { key : 'key', confirmation_id : 'confirmation_id', code : 'code', display_name : 'display_name', callback : -> }
  auth = createAuth key

  auth.confirmCode confirmation_id, code, display_name, callback

  ok auth.client.transport.get.calledWith '/api/auth/confirm_code', { confirmation_id : 'confirmation_id', code : 'code', display_name : 'display_name' }, callback

test 'registerEmail', ->
  { key, email, callback } = { key : 'key', email : 'email', callback : -> }
  auth = createAuth key

  auth.registerEmail email, callback

  ok auth.client.transport.get.calledWith '/api/auth/email', { email : 'email' }, callback


createAuth = (key)->
  client = new ChatleClient key
  client.transport.get = sinon.spy()
  client.transport.post = sinon.spy()
  client.transport.put = sinon.spy()
  client.transport.delete = sinon.spy()

  new ChatleClient.Auth client