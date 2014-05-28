GUID_CHARS = '0123456789QWERTYUIOPASDFGHJKLZXCVBNM'

class Transport
  constructor: (@frame_url, @key)->
    throw new Error('ChatleClient.Transport constructor call without frame_url') if !@frame_url?
    throw new Error('ChatleClient.Transport constructor call without key') if !@key?

    @id = @generateGuid()
    @loaded = false
    @queue = []

    @iframe = document.createElement 'iframe'
    @iframe.src = "#{@frame_url}##{@id}"
    @iframe.setAttribute 'style', 'width:0;height:0;display:none'

    document.body.appendChild @iframe

    @commands = { index : 0 }

    window.addEventListener 'message', @onload

  onload: (event)=>
    return if !event? || !event.data? || event.data.id != @id

    @loaded = true
    while @queue.length > 0
      command = @queue.shift()
      @sendCommand command.type, command.url, command.data, command.callback

    window.removeEventListener 'message', @onload
    window.addEventListener 'message', @onmessage

  onmessage: (event)=>
    result = event.data
    data = @commands[result.id]
    return unless data?
    delete @commands[result.id]
    data.callback? (if result.status == 'ok' then null else result.errorStatus), (if result.status == 'ok' then result.data else null)

  generateGuid: ->
    result = ''
    result += GUID_CHARS[Math.round(Math.random() * (GUID_CHARS.length - 1))] for i in [0..31]
    result

  sendCommand: (type, url, data, callback)->
    return @queue.push({ type, url, data, callback }) unless @loaded
    data = { command : { id : "#{@id}_#{@commands.index++}", type : type, url : url, data : data, headers : { "X-AppKey" : @key } }, callback : callback }
    if @authToken?
      data.command.headers = {} unless data.command.headers?
      data.command.headers['X-Auth-Token'] = @authToken

    @commands[data.command.id] = data
    @iframe.contentWindow.postMessage(data.command, '*');

  get: (url, data, callback)->
    @sendCommand 'GET', url, data, callback

  post: (url, data, callback)->
    @sendCommand 'POST', url, data, callback

  put: (url, data, callback)->
    @sendCommand 'PUT', url, data, callback

  delete: (url, data, callback)->
    @sendCommand 'DELETE', url, data, callback

  deactivate: ->
    window.removeEventListener 'message', @onload
    window.removeEventListener 'message', @onmessage
    @iframe.parentNode.removeChild @iframe


ChatleClient.Transport = Transport