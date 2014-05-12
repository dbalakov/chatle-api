#TODO Add init transport callback
#TODO Add transport_id
#TODO Remove add & add async
#TODO Test it all :)

class Transport
  constructor: (@frame_url, @key)->
    throw new Error('ChatleClient.Transport constructor call without frame_url') if !@frame_url?
    throw new Error('ChatleClient.Transport constructor call without key') if !@key?

    @iframe = document.createElement 'iframe'
    @iframe.src = @frame_url
    @iframe.setAttribute 'style', 'width:0;height:0;display:none'
    document.body.appendChild @iframe

    @queue = []
    @data = null

    window.addEventListener 'message', (event)=>
      return unless @data?
      result = event.data
      @data.callback? (if result.status == 'ok' then null else result.errorStatus), (if result.status == 'ok' then result.data else null)
      @data = null

  interval : ->
    if @data?
      hash = @iframe.src.split('#')[1]
      return if !hash? || hash == @data.hash || hash == ''
      result = JSON.parse hash
      @data.callback? (if result.status == 'ok' then null else result.errorStatus), (if result.status == 'ok' then result.data else null)
      @data = null
    @sendCommandToFrame()

  sendCommandToFrame: ->
    return if @data? || @queue.length == 0
    @data = @queue.shift()
    if @authToken? #TODO Test it
      @data.command.headers = {} unless @data.command.headers?
      @data.command.headers['X-Auth-Token'] = @authToken

    @iframe.contentWindow.postMessage(@data.command, '*');

  sendCommand: (type, url, data, callback)->
    @queue.push { command : { id : 1, type : type, url : url, data : data, headers : { "X-AppKey" : @key } }, callback : callback }
    @sendCommandToFrame()

  get: (url, data, callback)->
    @sendCommand 'GET', url, data, callback

  post: (url, data, callback)->
    @sendCommand 'POST', url, data, callback

  put: (url, data, callback)->
    @sendCommand 'PUT', url, data, callback

  delete: (url, data, callback)->
    @sendCommand 'DELETE', url, data, callback

ChatleClient.Transport = Transport