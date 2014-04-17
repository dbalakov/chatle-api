cwd = process.cwd()

http       = require 'http'
express    = require 'express'
Mincer     = require 'mincer'

config     = require "#{cwd}/tests/config"

app = express()
server = http.createServer(app)
app.set 'server', server


Mincer.logger.use {
  log   : ()->
  debug : ()->
  info  : ()->
  warn  : ()->
  error : console.error.bind(console)
}

mincerEnv = new Mincer.Environment
mincerEnv.appendPath 'vendor'
mincerEnv.appendPath 'output'
mincerEnv.appendPath "tests/assets/scripts"
mincerEnv.appendPath "tests/assets/stylesheets"

app.use express.static("tests/public")
app.use '/assets', Mincer.createServer(mincerEnv)

appServer = server.listen config.port, ->
  console.log "Test server started on #{new Date} (port: #{config.port})"