describe 'TableStore', ->
  TableStore = require '../src/coffeescripts/table-store.coffee'
  TableState = require '../src/coffeescripts/table-state.coffee'
  store = null

  beforeEach ->
    store = new TableStore
      header: [
        {key: 'name', label: 'Name', sortable: false}
        {key: 'value', label: 'Value'}
      ]
      items: [
        {name: 'apple', value: 200}
        {name: 'orange', value: 300}
      ]

  describe '#pushCurrentStateInFutureStates', ->
    before ->
      store.pushCurrentStateInFutureStates()

    it '@futureStatesに@stateの値が格納されていること', ->
      expect(store.futureStates.length).to.equal 1
      expect(store.futureStates).to.include store.state

  describe '#popFromFutureStates', ->
    newState = new TableState()

    before ->

    it '', ->
      expect(store.popFromFutureStates()).to.equal newState

