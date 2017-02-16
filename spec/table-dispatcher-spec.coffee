describe 'TableDispatcher', ->
  TableDispatcher = require '../src/coffeescripts/table-dispatcher.coffee'
  TableStore = require '../src/coffeescripts/table-store.coffee'
  TableAction = require '../src/coffeescripts/table-action.coffee'

  store = null
  dispatcher = null

  beforeEach ->
    store = new TableStore
      header: [
        {key: 'name', label: 'Name', sortable: false}
        {key: 'value', label: 'Value'}
      ]
      items: [
        {name: 'foo', value: '500'}
        {name: 'bar', value: '200'}
      ]
    dispatcher = new TableDispatcher store

  describe '#dispatch', ->
    it '@storeに対してactionが適用されていること'

