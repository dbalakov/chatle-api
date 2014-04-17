nconf = require 'nconf'

cwd = process.cwd()

nconf.argv()
nconf.argv()
nconf.use 'application', { type: 'file', file: "#{cwd}/tests/config/application.json" }

module.exports = nconf.get()