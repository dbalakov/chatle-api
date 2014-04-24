cwd = process.cwd()

fs = require 'fs'

VERSION_PATH = "#{cwd}/version"
PACKAGE_PATH = "#{cwd}/package.json"
BOWER_PATH   = "#{cwd}/bower.json"

version = []
version.push(parseInt(ver)) for ver in fs.readFileSync(VERSION_PATH).toString().split('.')
version[version.length - 1] += 1
version = version.join '.'

package_description = JSON.parse fs.readFileSync(PACKAGE_PATH).toString()
package_description.version = version

bower_description = JSON.parse fs.readFileSync(BOWER_PATH).toString()
bower_description.version = version

fs.writeFileSync VERSION_PATH, version
fs.writeFileSync PACKAGE_PATH, JSON.stringify(package_description, null, 2)
fs.writeFileSync BOWER_PATH, JSON.stringify(bower_description, null, 2)

