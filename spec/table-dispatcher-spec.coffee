describe 'TableDispatcher', ->
  TableDispatcher = require '../src/coffeescripts/table-dispatcher.coffee'
  store = null
  dispatcher = null

  beforeEach ->
    store = new TableStore()
    dispatcher = new TableDispatcher store

  describe '#dispatch', ->
    it '@storeに対してactionが適用されていること'

