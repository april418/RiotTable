class TableAction
  class MissingActionTypeError extends Error
    constructor: ->
      super 'Action type is required.'

  constructor: (type, params) ->
    throw new MissingActionTypeError() unless type
    @type = type
    @params = params

  getType: ->
    @type

  getParams: ->
    @params


module.exports = TableAction

