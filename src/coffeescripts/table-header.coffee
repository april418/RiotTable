TableColumn = require './table-column.coffee'


class TableHeader
  class MultipleOrderColumnError extends Error
    constructor: ->
      super 'Can only set order to one column.'

  @INITIAL_STATE:
    columns: []

  constructor: (header_params = []) ->
    @validateMultipleOrder header_params
    Object.assign @, TableHeader.INITIAL_STATE
    @initializeHeader header_params

  clone: ->
    clone = new TableHeader()
    clone.columns = []
    for column in @columns
      clone.columns.push column.clone()
    clone

  addNewColumn: (column_params) ->
    @columns.push new TableColumn column_params

  initializeHeader: (header_params) ->
    for column_params in header_params
      @addNewColumn column_params

  findColumn: (key) ->
    for column in @columns
      return column if column.key is key
    null

  findOrderColumn: ->
    for column in @columns
      return column if column.order?
    null

  setOrder: (key, order) ->
    for column in @columns
      if column.key is key
        column.setOrder order
      else
        column.resetOrder()

  getOrder: (key) ->
    @findColumn(key)?.getOrder()

  getColumns: ->
    @columns

  validateMultipleOrder: (header_params) ->
    order_columns = header_params.filter (column_params) ->
      column_params.order?
    throw new MultipleOrderColumnError if order_columns.length > 1


module.exports = TableHeader

