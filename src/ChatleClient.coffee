class ChatleClient
  constructor: (@key, @host, @transport, onload)->
    throw new Error('ChatleClient constructor call without api key') if !@key?
    @host = ChatleClient.DEFAULT_HOST if !@host?
    @transport = new ChatleClient.Transport(@host, @key, onload) if !@transport?

    @auth = new ChatleClient.Auth @
    @rooms = new ChatleClient.Rooms @
    @users = new ChatleClient.Users @

  setAuthToken: (token)->
    @transport.authToken = token

  deactivate: ->
    @transport.deactivate()

ChatleClient.DEFAULT_HOST = 'https://chatle.co/system/widgets/api/api.html'

window.ChatleClient = ChatleClient