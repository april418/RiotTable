class XHR
  class MissingUrlError extends Error
    constructor: ->
      super 'URL is required.'

  @INITIAL_STATE:
    url: null
    method: 'GET'
    dataType: 'json'
    data: {}
    async: true

  constructor: (options = {}) ->
    throw new MissingUrlError() unless options.url?
    Object.assign @, XHR.INITIAL_STATE, options

  createGetParameter: ->
    '?' + ("#{k}=#{v}" for k, v of @data).join '&'

  send: ->
    @url += @createGetParameter if @method is 'GET' and @data?

    new Promise (resolve, reject) =>
      request = new XMLHttpRequest()
      request.open @method, @url, @async
      request.responseType = @dataType
      request.onreadystatechange = ->
        return unless request.readyState is 4
        if 100 <= request.status and request.status <= 399
          resolve request.response
        else
          reject request.status, request.statusText


module.exports = XHR

