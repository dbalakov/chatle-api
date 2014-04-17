class Transport
  constructor: (@host, @key)->
    throw new Error('ChatleClient.Transport constructor call without host') if !@host?
    throw new Error('ChatleClient.Transport constructor call without key') if !@key?

  get: (url, data, callback)->
    $.ajax {
      type    : 'GET'
      url     : "#{@host}/#{url}"
      data    : data
      headers : { 'X-AppKey' : @key }
      success : (result)-> callback? null, result
      error   : (req, status)-> callback? status
    }

  post: (url, data, callback)->
    $.ajax {
      type     : 'POST'
      url      : "#{@host}/#{url}"
      data     : data
      headers  : { 'X-AppKey' : @key }
      success  : (result)-> callback? null, result
      error    : (req, status)-> callback? status
    }

  put: (url, data, callback)->
    $.ajax {
      type     : 'PUT'
      url      : "#{@host}/#{url}"
      data     : data
      headers  : { 'X-AppKey' : @key }
      success  : (result)-> callback? null, result
      error    : (req, status)-> callback? status
    }

  delete: (url, data, callback)->
    $.ajax {
      type     : 'DELETE'
      url      : "#{@host}/#{url}"
      data     : data
      headers  : { 'X-AppKey' : @key }
      success  : (result)-> callback? null, result
      error    : (req, status)-> callback? status
    }

ChatleClient.Transport = Transport