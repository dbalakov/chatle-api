HOST = 'https://chatle.co'

class ChatleClient
  constructor: (@key, @host, @transport)->
    throw new Error('ChatleClient constructor call without api key') if !@key?
    @host = HOST if !@host?
    @transport = new ChatleClient.Transport(@host, @key) if !@transport?

    @auth = new ChatleClient.Auth @
    @rooms = new ChatleClient.Rooms @
    @users = new ChatleClient.Users @

ChatleClient.DEFAULT_HOST = 'https://chatle.co'

window.ChatleClient = ChatleClient