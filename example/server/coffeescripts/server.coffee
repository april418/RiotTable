http = require 'http'

class Server
  constructor: (options = {}) ->
    @port = options.port ? 8080
    @router = options.router

  onRequest: (request, response) =>
    console.log "Request received."
    requestData = ''

    request.setEncoding 'utf-8'

    request.addListener 'data', (chunkedRequestData) =>
      console.log 'Received POST data chunk.'
      requestData += chunkedRequestData

    request.addListener 'end', =>
      console.log 'Finished to receive POST data.'
      @router.route request, requestData, response

  start: ->
    http.createServer @onRequest
      .listen @port
    console.log 'Server running.'

module.exports = Server
