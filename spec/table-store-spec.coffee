describe 'TableStore', ->
  TableStore = require '../src/coffeescripts/table-store.coffee'
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
    beforeEach ->
      store.pushCurrentStateInFutureStates()

    it '@futureStatesに@stateの値が格納されていること', ->
      expect(store.futureStates.length).to.equal 1
      expect(store.futureStates).to.include store.state

  describe '#popFromFutureStates', ->
    beforeEach ->
      store.pushCurrentStateInFutureStates()

    it '取得した値が@stateの値と同じこと', ->
      expect(store.popFromFutureStates()).to.eql store.state

    it '取得したインスタンスが@stateと別物であること', ->
      beforeEach ->
        store.state.setHeader()

      expect(store.popFromFutureStates()).to.not.eql store.state

