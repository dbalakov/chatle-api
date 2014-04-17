HOST = 'https://chatle.co'

class ChatleClient
  constructor: (@key)->
    throw new Error('ChatleClient constructor call without api key') if arguments.length == 0
    @host = if arguments.length > 1 then arguments[1] else HOST
    @transport = if arguments.length > 2 then arguments[2] else new ChatleClient.Transport(@key)

ChatleClient.DEFAULT_HOST = 'https://chatle.co'

window.ChatleClient = ChatleClient