class Users
  constructor: (@client)->
    throw new Error('ChatleClient.Users constructor call without client') if !@client?

  me: (callback)->
    @client.transport.get "#{Users.URL}/#{Users.ME_URL}", null, callback

  info: (id, callback)->
    @client.transport.get "#{Users.URL}/#{id}", null, callback

  update: (first_name, last_name, display_name, callback)->
    @client.transport.post "#{Users.URL}/#{Users.UPDATE_URL}", { first_name : first_name, last_name : last_name, display_name : display_name }, callback

Users.URL = 'api/users'

Users.ME_URL = 'me'
Users.UPDATE_URL = 'me'

ChatleClient.Users = Users