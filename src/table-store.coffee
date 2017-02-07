RegExp.escape = (string) ->
  string.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'


ORDER =
  ASC: 'asc'
  DESC: 'desc'

ORDER_VALUES = [
  ORDER.ASC
  ORDER.DESC
]


class BaseObject extends Object
  constructor: (object = {}) ->
    Object.assign @, object

  clone: ->
    Object.assign new BaseObject(), @

  toObject: ->
    Object.assign {}, @

  toString: ->
    "{#{("#{k}: #{v}" for k, v of @).join ','}}"

  keys: ->
    Object.keys @

  values: ->
    (v for k, v of @)

  each: (block) ->
    for k, v of @
      block k, v

  map: (block) ->
    (block k, v for k, v of @)

  all: (block) ->
    for k, v of @
      unless block k, v
        return false
    true

  any: (block) ->
    for k, v of @
      if block k, v
        return true
    false

  match: (term) ->
    @any (k, v) ->
      new RegExp(RegExp.escape term).test v


class TableItem extends BaseObject
  clone: ->
    Object.assign new TableItem(), @

  getValue: (key) ->
    @[key]


class TableItems
  @INITIAL_STATE:
    items: []
    count: 0

  constructor: (items) ->
    Object.assign @, TableItems.INITIAL_STATE
    @addItems items if items

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

  getItems: ->
    @items

  setItems: (items) ->
    @items = items if items

  getCount: ->
    @count

  sortedBy: (column, order) ->
    clone = @clone()
    return clone unless order?
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

  searchedBy: (term) ->
    items = new TableItems()
    if not term? or term.length is 0
      items.setItems @items
    else
      items.setItems @items.filter (item) -> item.match term
    items

  pagenatedBy: (page, per) ->
    items = new TableItems()
    items.setItems @items[((page - 1) * per)...(page * per - 1)]
    items

  each: (block) ->
    for item in @items
      block item

  map: (block) ->
    (block item for item in @items)


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
  @INITIAL_STATE:
    columns: []

  constructor: (header = []) ->
    Object.assign @, TableHeader.INITIAL_STATE
    @setHeader header

  clone: ->
    Object.assign new TableHeader(), @

  clone: ->
    clone = new TableHeader()
    clone.columns = []
    for column in @columns
      clone.columns.push column.clone()
    clone

  addColumn: (column) ->
    @columns.push new TableColumn column

  setHeader: (header) ->
    for column in header
      @addColumn column

  findColumn: (key) ->
    for column in @columns
      return column if column.key is key
    null

  setOrder: (column, order) ->
    @findColumn(column)?.setOrder order

  getColumns: ->
    @columns


class TableState
  @INITIAL_STATE:
    header: new TableHeader()
    items: new TableItems()
    sortColumn: null
    sortOrder: null
    searchTerm: null
    page: 0
    per: 25
    totalPages: 0
    totalCount: 0

  constructor: (params = {}) ->
    Object.assign @, TableState.INITIAL_STATE, params
    @setHeader params.header if params.header?
    @setItems params.items if params.items?

  clone: ->
    clone = Object.assign new TableState(), @
    clone.header = @header.clone()
    clone.items = @items.clone()
    clone

  setHeader: (header) ->
    @header = new TableHeader header

  setItems: (items) ->
    @items = new TableItems items
    @totalCount = @items.getCount()
    @page = 1 if @totalCount > 0
    @totalPages = Math.ceil(@totalCount / @per)

  setSearchTerm: (term) ->
    return unless term
    @searchTerm = term

  setSortColumn: (column) ->
    @sortColumn = column

  getSortColumn: ->
    @sortColumn

  setSortOrder: (order) ->
    @sortOrder = order

  getSortOrder: ->
    @sortOrder

  setPage: (page) ->
    return if page < 1 or page > @totalPages
    @page = page

  moveToNextPage: ->
    return if @isLastPage()
    @setPage(@page + 1)

  moveToPreviousPage: ->
    return if @isFirstPage()
    @setPage(@page - 1)

  moveToFirstPage: ->
    @setPage 1

  moveToLastPage: ->
    @setPage @totalPages

  getHeader: ->
    @header.getColumns()

  getItems: ->
    @items.searchedBy @searchTerm
      .sortedBy @sortColumn, @sortOrder
      .pagenatedBy @page, @per
      .getItems()

  canPagenate: ->
    @totalPages > 1

  pageIterator: ->
    if @totalPages > 1 then [1..@totalPages] else []

  isCurrentPage: (page) ->
    page? and page is @page

  isFirstPage: ->
    @page is 1

  isLastPage: ->
    @page is @totalPages


class TableStore
  @INITIAL_STATE:
    state: new TableState()
    nextStatus: []
    prevStatus: []

  constructor: (params ={}) ->
    Object.assign @, TableStore.INITIAL_STATE
    @setState params

  setState: (params) ->
    @state = new TableState params

  getState: ->
    @state

  pushPrevState: ->
    @prevStatus.push @state.clone()

  popPrevState: ->
    @prevStatus.pop()

  pushNextState: ->
    @nextStatus.push @state.clone()

  popNextState: ->
    @nextStatus.pop()

  undo: ->
    @pushNextState()
    @state = @popPrevState()

  redo: ->
    @pushPrevState()
    @state = @popNextState()

  search: (term) ->
    @pushPrevState()
    @state.setTerm term

  sort: (column) ->
    @pushPrevState()
    key = column.key
    if @state.getSortColumn() is key
      if @state.getSortOrder() is ORDER.ASC
        @state.setSortOrder ORDER.DESC
        column.setOrder ORDER.DESC
      else
        @state.setSortOrder ORDER.ASC
        column.setOrder ORDER.ASC
    else
      if column.getOrder() is ORDER.ASC
        @state.setSortOrder ORDER.DESC
        column.setOrder ORDER.DESC
      else
        @state.setSortOrder ORDER.ASC
        column.setOrder ORDER.ASC
    @state.setSortColumn key

  pagenate: (page) ->
    @pushPrevState()
    @state.setPage page

  nextPage: ->
    @pushPrevState()
    @state.moveToNextPage()

  previousPage: ->
    @pushPrevState()
    @state.moveToPreviousPage()

  firstPage: ->
    @pushPrevState()
    @state.moveToFirstPage()

  lastPage: ->
    @pushPrevState()
    @state.moveToLastPage()

  getHeader: ->
    @state.getHeader()

  getItems: ->
    @state.getItems()

  canPagenate: ->
    @state.canPagenate()

  isFirstPage: ->
    @state.isFirstPage()

  isLastPage: ->
    @state.isLastPage()

  isCurrentPage: (page) ->
    @state.isCurrentPage page

  pageIterator: ->
    @state.pageIterator()


module.exports = TableStore

