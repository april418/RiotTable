describe 'TableItem', ->
  TableItem = require '../src/coffeescripts/table-item.coffee'

  beforeEach =>
    @item = new TableItem
      hoge: 1
      huga: 4

  describe '#clone', =>
    beforeEach =>
      @clone = @item.clone()

    it '自身とクローンが同値であること', =>
      expect(@item).to.eql @clone

    it 'クローンが変更されても自身が変更されないこと', =>
      @clone.hoge = 100
      expect(@item).to.not.eql @clone

  describe '#getValue', =>
    it '返却値が正しいこと', =>
      expect(@item.getValue 'hoge').to.equal 1

