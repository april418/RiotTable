TableItems = require './table-items.coffee'
XHR = require './xhr.coffee'


class AjaxTableItems extends TableItems
  class MissingUrlError extends Error
    constructor: ->
      super 'Url is required.'

  @INITIAL_STATE:
    url: null
    items: []
    count: 0
    loading: false
    convertResponseData: null
    convertRequestData: (data) -> data?.items ? []

  constructor: (params = {}) ->
    throw new MissingUrlError unless params.url
    @setUrl params.url
    @setResponseDataConverter params.convertResponse
    @setRequestDataConverter params.convertRequest

  setUrl: (url) ->
    @url = url

  setResponseDataConverter: (converter) ->
    @convertResponseData = converter

  setRequestDataConverter: (converter) ->
    @convertRequestData = converter

  isLoading: ->
    @loading

  filteredBy: (params = {}) ->
    data = @convertRequestData params
    @loading = true
    xhr = new XHR(
      url: @url
      data: data
    ).then (data) =>
      @setItems @convertResponseData data
      @loading = false
    , (error) =>
      @loading = false


module.exports = AjaxTableItems

