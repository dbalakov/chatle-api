module 'Transport'

test 'Constructor', ->
  throws (-> client = new ChatleClient.Transport), 'Constructor without frame_url throw exception'
  throws (-> client = new ChatleClient.Transport 'host'), 'Constructor without key throw exception'

  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'

  equal transport.frame_url, 'https://chatle.co/system/widgets/_out/api.html', 'See valid frame_url'
  equal transport.key, 'key', 'See valid key'
  equal transport.iframe.nodeType, 1, 'See valid iframe.nodeType'
  equal transport.iframe.tagName, 'IFRAME', 'See valid iframe.tagName'
  equal transport.iframe.parentNode, document.body, 'See valid iframe.parentNode'
  equal transport.iframe.getAttribute('style'), 'width:0;height:0;display:none'

asyncTest 'interval: call sendCommandToFrame', ->
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'
  called = false
  transport.sendCommandToFrame = ->
    return if called
    called = true
    ok (-> called), 'called'

  setTimeout (-> start()), 1000

test "interval: transport busy - didn't call sendCommandToFrame", ->
  transport = new ChatleClient.Transport 'https://chatle.co/system/widgets/_out/api.html', 'key'
  transport.data = { hash : '' }
  transport.sendCommandToFrame = sinon.spy()
  transport.interval()
  ok transport.sendCommandToFrame.notCalled, "didn't call sendCommandToFrame"

test "interval: call callback with data", ->
  data = { hash : '', callback : sinon.spy() }
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.data = data
  transport.iframe.src = 'http://localhost:3300/tests.html#{"status":"ok","data":{"a":1}}'
  transport.interval()
  ok data.callback.calledWith(null, { a : 1 }), 'Called with valid arguments'

test "interval: call callback with error", ->
  data = { hash : '', callback : sinon.spy() }
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.data = data
  transport.iframe.src = 'http://localhost:3300/tests.html#{"status":"error","errorStatus":404}'
  transport.interval()
  ok data.callback.calledWith(404, null), 'Called with valid arguments'

test "sendCommandToFrame", ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.queue.push { command : { type : 'get', url : 'api/url', data : 'data' } }

  transport.sendCommandToFrame()

  equal transport.iframe.src, 'http://localhost:3300/tests.html#{"type":"get","url":"api/url","data":"data"}', 'See valid iframe url'
  equal transport.queue.length, 0, 'See valid queue'

test "sendCommand", ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommandToFrame = sinon.spy()

  transport.sendCommand 'GET', 'api/url', { a : 1 }, callback

  deepEqual transport.queue, [ { command : { type : 'GET', url : 'api/url', data : { a : 1 }, headers : { "X-AppKey" : 'key' } }, callback : callback } ], 'See valid queue'
  ok transport.sendCommandToFrame.calledOnce, 'sendCommandToFrame called'

test 'get', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.get 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('GET', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

test 'post', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.post 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('POST', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

test 'put', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.put 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('PUT', 'api/url', { a : 1 }, callback), 'Called with valid arguments'

test 'delete', ->
  callback = ->
  transport = new ChatleClient.Transport 'http://localhost:3300/tests.html', 'key'
  transport.sendCommand = sinon.spy()

  transport.delete 'api/url', { a : 1 }, callback

  ok transport.sendCommand.calledWith('DELETE', 'api/url', { a : 1 }, callback), 'Called with valid arguments'