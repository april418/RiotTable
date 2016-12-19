urlParser = require 'url'

ROUTES =
  '/': 'app/bin/client/html/index.html'
  '/post': ''

class Router
  constructor: (options = {}) ->
    @handler = options.handler
    @routes = options.routes ? ROUTES

  route: (request, requestData, response) ->
    url = request.url
    parsedUrl = urlParser.parse url
    requestUrl = parsedUrl.pathname
    console.log "About to route a request for #{requestUrl}"
    requestPath = @routes[url] ? ".#{requestUrl}"
    @handler.handle requestPath, requestData, response

module.exports = Router
