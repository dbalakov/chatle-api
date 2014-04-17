module 'Transport'

test 'Constructor', ->
  throws (-> client = new ChatleClient), 'Constructor without key throw exception'
  transport = new ChatleClient.Transport 'key'
  equal transport.key, 'key', 'See valid key'

test 'get', ->
  { key, url, data } = { key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport key
  transport.get url, data
  ok $.ajax.calledWithMatch {
    type    : 'GET'
    url     : url
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'get: success', ->
  { key, url, data, result, callback } = { key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport key
  transport.get url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'get: error', ->
  { key, url, data, error, callback } = { key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport key
  transport.get url, data, callback
  ok callback.calledWith(error), 'Call callback'

test 'post', ->
  { key, url, data } = { key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport key
  transport.post url, data
  ok $.ajax.calledWithMatch {
    type    : 'POST'
    url     : url
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'post: success', ->
  { key, url, data, result, callback } = { key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport key
  transport.post url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'post: error', ->
  { key, url, data, error, callback } = { key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport key
  transport.post url, data, callback
  ok callback.calledWith(error), 'Call callback'

test 'put', ->
  { key, url, data } = { key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport key
  transport.put url, data
  ok $.ajax.calledWithMatch {
    type    : 'PUT'
    url     : url
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'put: success', ->
  { key, url, data, result, callback } = { key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport key
  transport.put url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'put: error', ->
  { key, url, data, error, callback } = { key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport key
  transport.put url, data, callback
  ok callback.calledWith(error), 'Call callback'

test 'delete', ->
  { key, url, data } = { key : 'key', url : 'url', data : 'data' }
  $.ajax = sinon.spy()
  transport = new ChatleClient.Transport key
  transport.delete url, data
  ok $.ajax.calledWithMatch {
    type    : 'DELETE'
    url     : url
    data    : data
    headers : { 'X-AppKey' : key }
  }

test 'delete: success', ->
  { key, url, data, result, callback } = { key : 'key', url : 'url', data : 'data', result : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.success result
  transport = new ChatleClient.Transport key
  transport.delete url, data, callback
  ok callback.calledWith(null, result), 'Call callback'

test 'delete: error', ->
  { key, url, data, error, callback } = { key : 'key', url : 'url', data : 'data', error : 'result', callback : sinon.spy() }
  $.ajax = (settings)-> settings.error null, error
  transport = new ChatleClient.Transport key
  transport.delete url, data, callback
  ok callback.calledWith(error), 'Call callback'