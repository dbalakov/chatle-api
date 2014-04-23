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

    setInterval @interval.bind(@)

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
    @data.hash = JSON.stringify @data.command
    @iframe.src = "#{@frame_url}##{@data.hash}"

  sendCommand: (type, url, data, callback)->
    @queue.push { command : { type : type, url : url, data : data, headers : { "X-AppKey" : @key } }, callback : callback }
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