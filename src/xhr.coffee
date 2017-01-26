class XHR
  constructor: (options) ->
    @url = options.url
    @method = options.method?.toUpperCase() ? 'GET'
    @contentType = options.contentType ? ''
    @data = options.data ? {}
    @async = options.async ? true
    # URLは必須
    throw new Error "URL is required." unless @url

  createGetParameter: ->
    '?' + ("#{k}=#{v}" for k, v of @data).join '&'

  send: ->
    # GETの場合はURLパラメータを足す
    @url += @createGetParameter if @method is 'GET' and @data?

    # Promiseを作って返す
    new Promise (resolve, reject) =>
      request = new XMLHttpRequest()
      request.open @method, @url, @async
      request.onreadystatechange = ->
        # 通信完了以外は処理しない
        return unless request.readyState is 4
        # 通信成功(100~300系)時
        if 100 <= request.status and request.status <= 399
          resolve request.response
        # 通信失敗(400~500系)時
        else
          reject request.status, request.statusText

module.exports = XHR

