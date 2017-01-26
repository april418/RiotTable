urlParser = require 'url'

ORIGIN = 'example/public'

ROUTES =
  '/': 'example/public/templates/index.html'

class Router
  constructor: (options = {}) ->
    @handler = options.handler
    @routes = options.routes ? ROUTES

  route: (request, requestData, response) ->
    url = request.url
    parsedUrl = urlParser.parse url
    requestUrl = parsedUrl.pathname
    console.log "About to route a request for #{requestUrl}"
    requestPath = @routes[url] ? "#{ORIGIN}#{requestUrl}"
    @handler.handle requestPath, requestData, response

module.exports = Router

