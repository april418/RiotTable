describe 'TableColumn', ->
  TableColumn = require '../src/coffeescripts/table-column.coffee'
  CONSTANTS = require '../src/coffeescripts/constants.coffee'
  ORDER = CONSTANTS.ORDER
  ORDER_VALUES = CONSTANTS.ORDER_VALUES

  column = null

  beforeEach ->
    column = new TableColumn
      key: 'hoge'
      label: 'ほげ'
      sortable: false
      order: ORDER.DESC

  describe '#constructor', ->
    it 'pending...'

  describe '#clone', ->
    clone = null

    beforeEach ->
      clone = column.clone()

    it '自身とクローンが同値であること', ->
      expect(clone).to.eql column

    it 'クローンを変更しても自身が変更されないこと', ->
      clone.key = 'huga'
      expect(clone).to.not.eql column

  describe '#getLabel', ->
    it '@labelと返却値が等しいこと', ->
      expect(column.getLabel()).to.equal column.label

  describe '#getKey', ->
    it '@keyと返却値が等しいこと', ->
      expect(column.getKey()).to.equal column.key

  describe '#getOrder', ->
    it '@orderと返却値が等しいこと', ->
      expect(column.getOrder()).to.equal column.order

  describe '#setOrder', ->
    beforeEach =>
      column.setOrder @order

    context '入力値がORDER_VALUESに含まれるとき', =>
      before =>
        @order = ORDER.ASC

      it '返却値が入力値と等しいこと', =>
        expect(column.getOrder()).to.equal @order

    context '入力値がORDER_VALUESに含まれないとき', =>
      before =>
        @order = 'foo'

      it '返却値が元々の値であること(変化していないこと)', ->
        expect(column.getOrder()).to.equal ORDER.DESC

  describe '#resetOrder', ->
    it ''

  describe 'isSortable', ->
    it ''

  describe 'isOrderAsc', ->
    it ''

  describe 'isOrderDesc', ->
    it ''

  describe 'isOrderDefault', ->
    it ''

