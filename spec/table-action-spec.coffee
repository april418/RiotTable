describe 'TableAction', ->
  TableAction = require '../src/coffeescripts/table-action.coffee'
  action = null

  beforeEach ->
    action = new TableAction 'test', 'I am test.'

  describe 'constructor', ->
    it '引数にtypeがないときエラーになること', ->
      (-> new TableAction()).should.throw()

  describe '#getType', ->
    it '@typeと同じ値が取得できること', ->
      expect(action.getType()).to.equal action.type

  describe '#getParams', ->
    it '@paramsと同じ値が取得できること', ->
      expect(action.getParams()).to.equal action.params

