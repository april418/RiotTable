TableState = require './table-state.coffee'


class TableStore
  constructor: (params ={}) ->
    @futureStates = []
    @pastStates = []
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

