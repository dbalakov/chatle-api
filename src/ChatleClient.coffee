class ChatleClient
  constructor: (@key, @host, @transport)->
    throw new Error('ChatleClient constructor call without api key') if !@key?
    @host = ChatleClient.DEFAULT_HOST if !@host?
    @transport = new ChatleClient.Transport(@host, @key) if !@transport?

    @auth = new ChatleClient.Auth @
    @rooms = new ChatleClient.Rooms @
    @users = new ChatleClient.Users @

  setAuthToken: (token)-> #TODO Test it
    @transport.authToken = token

ChatleClient.DEFAULT_HOST = 'https://chatle.co/system/widgets/api/api.html'

window.ChatleClient = ChatleClient