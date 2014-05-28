module 'Transport'

test 'Constructor', ->
  throws (-> client = new ChatleClient.Transport), 'Constructor without frame_url throw exception'
  throws (-> client = new ChatleClient.Transport 'host'), 'Constructor without key throw exception'

  addEventListener = window.addEventListener
  window.addEventListener = sinon.spy()
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'

  equal transport.frame_url, 'https://chatle.co/system/widgets/_out/api.html', 'See valid frame_url'
  equal transport.key, 'key', 'See valid key'
  equal transport.iframe.nodeType, 1, 'See valid iframe.nodeType'
  equal transport.iframe.tagName, 'IFRAME', 'See valid iframe.tagName'
  equal transport.iframe.parentNode, document.body, 'See valid iframe.parentNode'
  equal transport.iframe.src, "https://chatle.co/system/widgets/_out/api.html##{transport.id}", 'See valid iframe.src'
  equal transport.iframe.getAttribute('style'), 'width:0;height:0;display:none', 'See valid style'
  notEqual transport.id, null, 'See id'
  ok window.addEventListener.calledWith('message', transport.onload), 'Event listener'

  transport.deactivate()
  window.addEventListener = addEventListener

test 'onload: another id', ->
  callback = ->
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'
  transport.sendCommand 'GET', 'api/url', { a : 1 }, callback

  transport.onload({ data : { id : 'invalid id' } })

  equal transport.loaded, false, 'loaded'
  deepEqual transport.queue, [ { type : 'GET', url : 'api/url', data : { a : 1 }, callback : callback } ], 'See valid queue'

  transport.deactivate()

test 'onload: valid id', ->
  callback = ->
  post_callback = ->
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'
  transport.sendCommand 'GET', 'api/url', 'data', callback
  transport.sendCommand 'POST', 'api/_url', 'post_data', post_callback
  transport.sendCommand = sinon.spy()
  removeEventListener = window.removeEventListener
  window.removeEventListener = sinon.spy()
  addEventListener = window.addEventListener
  window.addEventListener = sinon.spy()

  transport.onload({ data : { id : transport.id } })

  equal transport.loaded, true, 'loaded'
  deepEqual transport.queue, [], 'See valid queue'
  ok transport.sendCommand.calledWith('GET', 'api/url', 'data', callback), 'Called get'
  ok transport.sendCommand.calledWith('POST', 'api/_url', 'post_data', post_callback), 'Called post'
  ok window.removeEventListener.calledWith('message', transport.onload), 'Remove event listener (onload)'

  window.removeEventListener = removeEventListener
  window.addEventListener = addEventListener
  transport.deactivate()

test 'deactivate', ->
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'
  removeChild = transport.iframe.parentNode.removeChild
  transport.iframe.parentNode.removeChild = sinon.spy()
  removeEventListener = window.removeEventListener
  window.removeEventListener = sinon.spy()

  transport.deactivate()

  ok window.removeEventListener.calledWith('message', transport.onload), 'Remove event listener (onload)'
  ok window.removeEventListener.calledWith('message', transport.onmessage), 'Remove event listener (onmessage)'
  ok transport.iframe.parentNode.removeChild.calledWith(transport.iframe), 'Remove iframe'

  transport.iframe.parentNode.removeChild = removeChild
  window.removeEventListener = removeEventListener
  transport.deactivate()

test 'onmessage', ->
  command_ok = { callback : sinon.spy() }
  command_error = { callback : sinon.spy() }
  data_ok = { }

  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'
  transport.commands['command_ok_id'] = command_ok
  transport.commands['command_error_id'] = command_error

  transport.onmessage { data : { id : 'command_ok_id', status : 'ok', data : data_ok } }
  transport.onmessage { data : { id : 'command_error_id', status : 'error', errorStatus : 404 } }

  ok command_ok.callback.calledWith(null, data_ok), 'Callback ok'
  ok command_error.callback.calledWith(404, null), 'Callback error'

  transport.deactivate()

test 'generateGuid', ->
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'

  equal transport.generateGuid().length, 32, 'GUID length'

  transport.deactivate()

test "sendCommand:not loaded", ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.iframe.contentWindow.postMessage = sinon.spy()
  transport.authToken = 'api auth-token'

  transport.sendCommand 'GET', 'api/url', { a : 1 }, callback

  ok transport.iframe.contentWindow.postMessage.notCalled, 'not called'
  deepEqual transport.queue, [ { type : 'GET', url : 'api/url', data : { a : 1 }, callback : callback } ], 'See valid queue'

  transport.deactivate()

test "sendCommand:loaded", ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.iframe.contentWindow.postMessage = sinon.spy()
  transport.loaded = true
  transport.authToken = 'api auth-token'

  transport.sendCommand 'GET', 'api/url', { a : 1 }, callback

  ok transport.iframe.contentWindow.postMessage.calledWith { id : "#{transport.id}_0", type : 'GET', url : 'api/url', data : { a : 1 }, headers : { "X-AppKey" : 'key', 'X-Auth-Token' : 'api auth-token' } }, '*'

  transport.deactivate()

test 'get', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.get 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('GET', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

  transport.deactivate()

test 'post', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.post 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('POST', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

  transport.deactivate()

test 'put', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.put 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('PUT', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

  transport.deactivate()

test 'delete', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.delete 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('DELETE', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

  transport.deactivate()