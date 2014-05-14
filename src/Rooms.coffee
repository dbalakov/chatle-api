GUID_CHARS = '0123456789QWERTYUIOPASDFGHJKLZXCVBNM'

class Rooms
  constructor: (@client)->
    throw new Error('ChatleClient.Rooms constructor call without client') if !@client?

  list: (callback)->
    @client.transport.get "#{Rooms.URL}", null, callback

  messages: (room, filter, callback)->
    @client.transport.get "#{Rooms.URL}/#{room}", filter, callback

  sendMessage: (room, message, callback)->
    @client.transport.post "#{Rooms.URL}/#{room}/#{Rooms.SEND_MESSAGE_URL}", { message : { text : message, guid : generateGuid() } }, callback

  deleteMessage: (room, message, callback)->
    @client.transport.delete "#{Rooms.URL}/#{room}/#{message}", null, callback

  createPrivate: (user, group, callback)->
    @client.transport.get "#{Rooms.URL}/#{Rooms.CREATE_PRIVATE_ROOM_URL}", { user_id : user, group : group }, callback

  createInviteOnly: (users, group, name, callback)->
    @client.transport.get "#{Rooms.URL}/#{Rooms.CREATE_INVITE_ONLY_URL}", { user_ids : users, group : group, name : name }, callback

  update: (room, group, name, mute, data, callback)->
    @client.transport.put "#{Rooms.URL}/#{room}", { group : group, name : name, mute : mute, data : data }, callback

  invite: (room, users, callback)->
    data = {}
    data[if users instanceof Array then 'user_ids' else 'user'] = users
    @client.transport.get "#{Rooms.URL}/#{room}/#{Rooms.INVITE_USERS}", data, callback

  leave: (room, callback)->
    @client.transport.get "#{Rooms.URL}/#{room}/#{Rooms.LEAVE}", null, callback

Rooms.URL = '/api/rooms'

Rooms.SEND_MESSAGE_URL        = 'message'
Rooms.CREATE_PRIVATE_ROOM_URL = 'private'
Rooms.CREATE_INVITE_ONLY_URL  = 'group'
Rooms.INVITE_USERS            = 'invite'
Rooms.LEAVE                   = 'leave'

generateGuid = ->
  result = ''
  result += GUID_CHARS[Math.round(Math.random() * (GUID_CHARS.length - 1))]
  result

ChatleClient.Rooms = Rooms