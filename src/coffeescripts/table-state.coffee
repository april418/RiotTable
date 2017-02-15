TableHeader = require './table-header.coffee'
TableItems = require './table-items.coffee'
CONSTANTS = require './constants.coffee'
ORDER = CONSTANTS.ORDER
ORDER_VALUES = CONSTANTS.ORDER_VALUES


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


module.exports = TableState

