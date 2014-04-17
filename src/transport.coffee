class Transport
  constructor: (@key)->
    throw new Error('ChatleClient.Transport constructor call without api key') if arguments.length == 0

  get: (url, data, callback)->
    $.ajax {
      type    : 'GET'
      url     : url
      data    : data
      headers : { 'X-AppKey' : @key }
      success : (result)-> callback? null, result
      error   : (req, status)-> callback? status
    }

  post: (url, data, callback)->
    $.ajax {
      type     : 'POST'
      url      : url
      data     : data
      headers  : { 'X-AppKey' : @key }
      success  : (result)-> callback? null, result
      error    : (req, status)-> callback? status
    }

  put: (url, data, callback)->
    $.ajax {
      type     : 'PUT'
      url      : url
      data     : data
      headers  : { 'X-AppKey' : @key }
      success  : (result)-> callback? null, result
      error    : (req, status)-> callback? status
    }

  delete: (url, data, callback)->
    $.ajax {
      type     : 'DELETE'
      url      : url
      data     : data
      headers  : { 'X-AppKey' : @key }
      success  : (result)-> callback? null, result
      error    : (req, status)-> callback? status
    }

window.ChatleClient.Transport = Transport