TableItem = require './table-item.coffee'
CONSTANTS = require './constants.coffee'
ORDER = CONSTANTS.ORDER
ORDER_VALUES = CONSTANTS.ORDER_VALUES


class TableItems
  @INITIAL_STATE:
    count: 0

  constructor: (items = []) ->
    Object.assign @, TableItems.INITIAL_STATE
    @items = []
    @addItems items

  clone: ->
    clone = new TableItems()
    clone.items = []
    for item in @items
      clone.items.push item.clone()
      clone.count++
    clone

  addItem: (item) ->
    @items.push new TableItem item
    @count++

  addItems: (items) ->
    for item in items
      @addItem item

  setItems: (items = [], setCount = true) ->
    @items = items
    @count = items.length if setCount

  getItems: ->
    @items

  getCount: ->
    @count

  isLoading: ->
    false

  searchedBy: (term) ->
    clone = @clone()
    return clone if not term? or term.length is 0
    clone.setItems clone.getItems().filter (item) -> item.match term
    clone

  sortedBy: (column, order) ->
    clone = @clone()
    return clone unless column? && order?
    order = order.toLowerCase()
    clone.getItems().sort (a, b) ->
      va = a[column]
      vb = b[column]
      return 0 if (ORDER_VALUES.indexOf(order) is -1) or (va is vb)
      if order is ORDER.ASC
        if va > vb then 1 else -1
      else if order is ORDER.DESC
        if va > vb then -1 else 1
    clone

  pagenatedBy: (page, per) ->
    clone = @clone()
    return clone unless page? && per?
    clone.setItems clone.getItems()[((page - 1) * per)..(page * per - 1)], false
    clone

  filteredBy: (params = {}) ->
    term = params.term
    column = params.column
    order = params.order
    page = params.page
    per = params.per

    @searchedBy term
      .sortedBy column, order
      .pagenatedBy page, per


module.exports = TableItems

