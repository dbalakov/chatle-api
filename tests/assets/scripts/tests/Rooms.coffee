module 'Rooms'

test 'Constructor', ->
  throws (-> new ChatleClient.Rooms), 'Constructor without ChatleClient throw exception'
  throws (-> new ChatleClient.Rooms null), 'Call constructor with (client=null) throw exception'
  key = 'key'
  client = new ChatleClient key
  rooms = new ChatleClient.Rooms client

  equal rooms.client, client, 'See valid client'

  client.deactivate()

test 'list', ->
  callback = ->
  rooms = createRooms 'key'
  rooms.list callback

  ok rooms.client.transport.get.calledWith '/api/rooms', null, callback

test 'messages', ->
  { id, filter, callback } = { id : 'room_id', filter : 'filter', callback : -> }
  rooms = createRooms 'key'

  rooms.messages id, filter, callback

  ok rooms.client.transport.get.calledWith '/api/rooms/room_id', filter, callback

test 'sendMessage', ->
  { id, message, callback } = { id : 'room_id', message : 'message_text', callback : -> }
  rooms = createRooms 'key'

  rooms.sendMessage id, message, callback

  args = rooms.client.transport.post.getCall(0).args
  ok rooms.client.transport.post.calledOnce, 'Post called'

  equal args[0], '/api/rooms/room_id/message', 'Valid url'
  equal args[1].message.text, message, 'Valid text'
  equal args[2], callback, 'Valid callback'

test 'deleteMessage', ->
  { id, message, callback } = { id : 'room_id', message : 'message_id', callback : -> }
  rooms = createRooms 'key'

  rooms.deleteMessage id, message, callback

  ok rooms.client.transport.delete.calledWith '/api/rooms/room_id/message_id', null, callback

test 'createPrivate', ->
  { user, group, callback } = { user : 'another_user', group : 'group', callback : -> }
  rooms = createRooms 'key'

  rooms.createPrivate user, group, callback

  ok rooms.client.transport.get.calledWith '/api/rooms/private', { user_id : 'another_user', group : 'group' }, callback

test 'createInviteOnly', ->
  { users, group, name, callback } = { users : [ 1, 2, 3, 5, 8 ], group : 'group', name : 'room_name', callback : -> }
  rooms = createRooms 'key'

  rooms.createInviteOnly users, group, name, callback

  ok rooms.client.transport.get.calledWith '/api/rooms/group', { user_ids : [ 1, 2, 3, 5, 8 ], group : 'group', name : 'room_name' }, callback

test 'update', ->
  { id, group, name, mute, data, callback } = { id : 'room_id', group : 'group', name : 'new_name', mute : false, data : 'hash_data', callback : -> }
  rooms = createRooms 'key'

  rooms.update id, group, name, mute, data, callback

  ok rooms.client.transport.put.calledWith '/api/rooms/room_id', { group : 'group', name : 'new_name', mute : false, data : 'hash_data' }, callback

test 'invite user', ->
  { id, user, callback } = { id : 'room_id', user : 'user_id', callback : -> }
  rooms = createRooms 'key'

  rooms.invite id, user, callback

  ok rooms.client.transport.get.calledWith '/api/rooms/room_id/invite', { user : user }, callback

test 'invite users', ->
  { id, users, callback } = { id : 'room_id', users : [ 2, 3, 5, 8, 13 ], callback : -> }
  rooms = createRooms 'key'

  rooms.invite id, users, callback

  ok rooms.client.transport.get.calledWith '/api/rooms/room_id/invite', { user_ids : users }, callback

test 'leave', ->
  { id, callback } = { id : 'room_id', callback : -> }
  rooms = createRooms 'key'

  rooms.leave id, callback

  ok rooms.client.transport.get.calledWith '/api/rooms/room_id/leave', null, callback

createRooms = (key)->
  client = new ChatleClient key
  client.transport.get = sinon.spy()
  client.transport.post = sinon.spy()
  client.transport.put = sinon.spy()
  client.transport.delete = sinon.spy()
  client.deactivate()

  new ChatleClient.Rooms client