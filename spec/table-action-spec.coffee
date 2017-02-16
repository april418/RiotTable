describe 'TableAction', ->
  TableAction = require '../src/coffeescripts/table-action.coffee'

  beforeEach =>
    @action = new TableAction 'test', 'I am test.'

  describe '#constructor', ->
    it '引数にtypeがないときエラーになること', ->
      expect(-> new TableAction()).to.throw TableAction.MissingActionTypeError

  describe '#getType', =>
    it '@typeと同じ値が取得できること', =>
      expect(@action.getType()).to.equal @action.type

  describe '#getParams', =>
    it '@paramsと同じ値が取得できること', =>
      expect(@action.getParams()).to.equal @action.params

