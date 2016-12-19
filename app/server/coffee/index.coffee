Server = require './server'
Router = require './router'
RequestHandler = require './request_handler'

handler = new RequestHandler()
router = new Router
  handler: handler
server = new Server
  router: router

server.start()
