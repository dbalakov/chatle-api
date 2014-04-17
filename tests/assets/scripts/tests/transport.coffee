module 'Transport'

test 'Constructor', ->
  throws (-> client = new ChatleClient.Transport), 'Constructor without host throw exception'
  throws (-> client = new ChatleClient.Transport 'host'), 'Constructor without key throw exception'

  transport = new ChatleClient.Transport 'host', 'key'

  equal transport.host, 'host', 'See valid host'
  equal transport.key, 'key', 'See valid key'

test 'get', ->
  { host, key, url, data } = { host : 'host', key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport host, key
  transport.get url, data
  ok $.ajax.calledWithMatch {
    type    : 'GET'
    url     : 'host/url'
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'get: success', ->
  { host, key, url, data, result, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport host, key
  transport.get url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'get: error', ->
  { host, key, url, data, error, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport host, key
  transport.get url, data, callback
  ok callback.calledWith(error), 'Call callback'

test 'post', ->
  { host, key, url, data } = { host : 'host', key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport host, key
  transport.post url, data
  ok $.ajax.calledWithMatch {
    type    : 'POST'
    url     : 'host/url'
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'post: success', ->
  { host, key, url, data, result, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport host, key
  transport.post url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'post: error', ->
  { host, key, url, data, error, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport host, key
  transport.post url, data, callback
  ok callback.calledWith(error), 'Call callback'

test 'put', ->
  { host, key, url, data } = { host : 'host', key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport host, key
  transport.put url, data
  ok $.ajax.calledWithMatch {
    type    : 'PUT'
    url     : 'host/url'
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'put: success', ->
  { host, key, url, data, result, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport host, key
  transport.put url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'put: error', ->
  { host, key, url, data, error, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport host, key
  transport.put url, data, callback
  ok callback.calledWith(error), 'Call callback'

test 'delete', ->
  { host, key, url, data } = { host : 'host', key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport host, key
  transport.delete url, data
  ok $.ajax.calledWithMatch {
    type    : 'DELETE'
    url     : 'host/url'
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'delete: success', ->
  { host, key, url, data, result, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport host, key
  transport.delete url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'delete: error', ->
  { host, key, url, data, error, callback } = { host : 'host', key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport host, key
  transport.delete url, data, callback
  ok callback.calledWith(error), 'Call callback'