class Auth
  constructor: (@client)->
    throw new Error('ChatleClient.Auth constructor call without client') if arguments.length == 0 || !@client?

  registerMobile: (number, callback)->
    @client.transport.get "#{Auth.URL}#{Auth.REGISTER_MOBILE_URL}", { number : number }, callback

  registerEmail: (email, callback)->
    @client.transport.get "#{Auth.URL}#{Auth.REGISTER_EMAIL_URL}", { email : email }, callback

  confirmCode: (confirmation_id, code, display_name, callback)->
    @client.transport.get "#{Auth.URL}#{Auth.CONFIRM_CODE_URL}", { confirmation_id : confirmation_id, code : code, display_name : display_name }, callback


Auth.URL = 'api/auth/'
Auth.REGISTER_MOBILE_URL = 'register_mobile'
Auth.REGISTER_EMAIL_URL = 'email'
Auth.CONFIRM_CODE_URL = 'confirm_code'

ChatleClient.Auth = Auth