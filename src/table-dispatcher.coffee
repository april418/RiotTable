class TableDispatcher
  constructor: (store) ->
    @store = store

  dispatch: (action) ->
    @store.receive action


module.exports = TableDispatcher

