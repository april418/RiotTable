XHR = require './xhr.coffee'
BaseObject = require './base_object.coffee'


ORDER =
  ASC: 'asc'
  DESC: 'desc'

ORDER_VALUES = [
  ORDER.ASC
  ORDER.DESC
]


class TableItem extends BaseObject
  clone: ->
    Object.assign new TableItem(), @

  getValue: (key) ->
    @[key]


class TableItems
  @INITIAL_STATE:
    items: []
    count: 0

  constructor: (items = []) ->
    Object.assign @, TableItems.INITIAL_STATE
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
    convertRequestData: null

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


class TableColumn extends BaseObject
  @INITIAL_STATE:
    key: null
    label: null
    sortable: true
    order: null

  constructor: (header = {}) ->
    Object.assign @, TableColumn.INITIAL_STATE, header

  clone: ->
    Object.assign new TableColumn(), @

  getLabel: ->
    @label

  getKey: ->
    @key

  getOrder: ->
    @order

  setOrder: (order) ->
    return if ORDER_VALUES.indexOf(order) is -1
    @order = order

  resetOrder: ->
    @order = TableColumn.INITIAL_STATE.order

  isSortable: ->
    @sortable

  isOrderAsc: ->
    @isSortable() and @order is ORDER.ASC

  isOrderDesc: ->
    @isSortable() and @order is ORDER.DESC

  isOrderDefault: ->
    @isSortable() and @order is TableColumn.INITIAL_STATE.order


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


class TableState
  @INITIAL_STATE:
    searchTerm: null
    page: 1
    per: 25
    totalCount: 0
    totalPages: 1

  constructor: (params = {}) ->
    Object.assign @, TableState.INITIAL_STATE, params
    @initializeHeader params.header
    @initializeItems params.items

  clone: ->
    clone = Object.assign new TableState(), @
    clone.header = @header.clone()
    clone.items = @items.clone()
    clone

  #
  # set / update state
  #

  setHeader: (header = []) ->
    @header = header

  initializeHeader: (header_params = []) ->
    @setHeader new TableHeader header_params

  setTotalCount: (count) ->
    @totalCount = count

  updateTotalPages: ->
    @totalPages = Math.ceil(@totalCount / @per)

  setItems: (items = []) ->
    @items = items
    @setTotalCount items.count
    @updateTotalPages()

  initializeItems: (item_params = []) ->
    @setItems new TableItems item_params

  setSearchTerm: (term) ->
    @searchTerm = term

  setSortColumn: (column) ->
    @sortColumn = column

  setPage: (page) ->
    @page = if page < 1
      1
    else if page > @totalPages
      @totalPages
    else
      page

  #
  # action
  #

  search: (term) ->
    clone = @clone()
    clone.setPage 1
    clone.setSearchTerm term
    clone

  sort: (column) ->
    clone = @clone()
    return clone if not column? or not column.isSortable()
    header = clone.getHeader()
    order = if column.getOrder() is ORDER.ASC then ORDER.DESC else ORDER.ASC
    header.setOrder column.getKey(), order
    clone

  moveTo: (page) ->
    clone = @clone()
    clone.setPage page
    clone

  moveToNextPage: ->
    clone = @clone()
    return clone if @isLastPage()
    clone.setPage(@page + 1)
    clone

  moveToPreviousPage: ->
    clone = @clone()
    return clone if @isFirstPage()
    clone.setPage(@page - 1)
    clone

  moveToFirstPage: ->
    clone = @clone()
    clone.setPage 1
    clone

  moveToLastPage: ->
    clone = @clone()
    clone.setPage @totalPages
    clone

  #
  # get state
  #

  getHeader: ->
    @header

  getColumns: ->
    @header.getColumns()

  getItems: ->
    column = @header.findOrderColumn()
    items = @items.filteredBy
      term: @searchTerm
      column: column?.getKey()
      order: column?.getOrder()
      page: @page
      per: @per
    @setTotalCount items.getCount()
    @updateTotalPages()
    items.getItems()

  getTotalCount: ->
    @items.getCount()

  getTotalPages: ->
    @items.getTotalPages()

  pageIterator: ->
    if @totalPages > 1 then [1..@totalPages] else []

  canPagenate: ->
    @totalPages > 1

  isCurrentPage: (page) ->
    page? and page is @page

  isFirstPage: ->
    @page is 1

  isLastPage: ->
    @page is @totalPages

  isLoading: ->
    @items.isLoading()

  hasItem: ->
    @totalCount > 0


class TableStore
  @INITIAL_STATE:
    futureStates: []
    pastStates: []

  constructor: (params ={}) ->
    Object.assign @, TableStore.INITIAL_STATE
    @initializeState params

  setState: (state) ->
    @state = state

  initializeState: (params) ->
    @setState new TableState params

  #
  # manage state
  #

  pushCurrentStateInFutureStates: ->
    @futureStates.push @state.clone()

  popFromFutureStates: ->
    @futureStates.pop()

  pushCurrentStateInPastStates: ->
    @pastStates.push @state.clone()

  popFromPastStates: ->
    @pastStates.pop()

  resetFutureStates: ->
    @futureStates = []

  beforeCreateNewState: ->
    @pushCurrentStateInPastStates()
    @resetFutureStates()

  #
  # action
  #

  search: (term) ->
    @beforeCreateNewState()
    @state.search term

  sort: (column) ->
    @beforeCreateNewState()
    @state.sort column

  moveTo: (page) ->
    @beforeCreateNewState()
    @state.moveTo page

  moveToNextPage: ->
    @beforeCreateNewState()
    @state.moveToNextPage()

  moveToPreviousPage: ->
    @beforeCreateNewState()
    @state.moveToPreviousPage()

  moveToFirstPage: ->
    @beforeCreateNewState()
    @state.moveToFirstPage()

  moveToLastPage: ->
    @beforeCreateNewState()
    @state.moveToLastPage()

  undo: ->
    @pushCurrentStateInFutureStates()
    @popFromPastStates()

  redo: ->
    @pushCurrentStateInPastStates()
    @popFromFutureStates()

  # receive action if dispatch it
  receive: (action) ->
    return unless action?
    newState = @reduce @state, action
    @setState newState

  # reducer
  reduce: (state, action) ->
    type = action.getType()
    method = @[type] ? state[type]
    method.call @, action.getParams()

  #
  # get state
  #

  getHeader: ->
    @state.getHeader()

  getColumns: ->
    @state.getColumns()

  getItems: ->
    @state.getItems()

  getPageIterator: ->
    @state.pageIterator()

  canPagenate: ->
    @state.canPagenate()

  isFirstPage: ->
    @state.isFirstPage()

  isLastPage: ->
    @state.isLastPage()

  isCurrentPage: (page) ->
    @state.isCurrentPage page

  isLoading: ->
    @state.isLoading()

  hasItem: ->
    @state.hasItem()

  canUndo: ->
    @prevStatus.length > 0

  canRedo: ->
    @nextStatus.length > 0


module.exports = TableStore

