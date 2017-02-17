describe 'TableItems', ->
  TableItems = require '../src/coffeescripts/table-items.coffee'
  TableItem = require '../src/coffeescripts/table-item.coffee'

  beforeEach =>
    @items = new TableItems [
      {name: 'foo', value: 100}
      {name: 'bar', value: 500}
      {name: 'baz', value: 80}
    ]

  describe '#constructor', =>
    it 'pending...'

  describe '#clone', =>
    beforeEach =>
      @clone = @items.clone()

    it '自身とクローンが同値であること', =>
      expect(@clone).to.eql @items

    it 'クローンを変更しても自身は変更されないこと', =>
      @clone.getItems()[0].name = 'foooo'
      expect(@clone).to.not.eql @items

  describe '#addItem', =>
    it 'itemが追加されていること', =>
      newItem = {name: 'bom', value: 7000}
      @items.addItem newItem
      expect(@items.getItems()).to.include new TableItem newItem

  describe '#addItems', =>
    it 'itemが追加されていること', =>
      newItem1 = {name: 'dom', value: 69000}
      newItem2 = {name: 'zaku', value: 5200}
      @items.addItems [newItem1, newItem2]
      expect(@items.getItems()).to.deep.include.members [
        new TableItem newItem1
        new TableItem newItem2
      ]

  describe '#setItems', =>
    beforeEach =>
      @newItems = [
        new TableItem {name: 'dom', value: 69000}
        new TableItem {name: 'zaku', value: 5200}
      ]

    context 'setCountがtrueのとき', =>
      it 'itemが追加されていること', =>
        @items.setItems @newItems, true
        expect(@items.getItems()).to.deep.include.members @newItems

      it 'countが変化していること', =>
        expect(=> @items.setItems @newItems, true).to.change @items, 'count'

    context 'setCountがfalseのとき', =>
      it 'itemが追加されていること', =>
        @items.setItems @newItems, false
        expect(@items.getItems()).to.deep.include.members @newItems

      it 'countが変化していないこと', =>
        expect(=> @items.setItems @newItems, false).to.not.change @items, 'count'

  describe '#getItems', =>
    it '返却値が正しいこと', =>
      expect(@items.getItems()).to.eql [
        new TableItem {name: 'foo', value: 100}
        new TableItem {name: 'bar', value: 500}
        new TableItem {name: 'baz', value: 80}
      ]

  describe '#getCount', =>
    it '返却値が正しいこと', =>
      expect(@items.getCount()).to.equal 3

  describe '#isLoading', =>
    it '返却値が正しいこと', =>
      expect(@items.isLoading()).to.be.false

  describe '#searchedBy', =>
    beforeEach =>
      @searched = @items.searchedBy 'b'

    it '返却値が正しいこと', =>
      expect(@searched.getItems()).to.eql [
        new TableItem {name: 'bar', value: 500}
        new TableItem {name: 'baz', value: 80}
      ]

    it '自身が変化していないこと', =>
      expect(@items).to.not.eql @searched

  describe '#sortedBy', =>
    beforeEach =>
      @sorted = @items.sortedBy 'value', 'asc'

    it '返却値が正しいこと', =>
      expect(@sorted.getItems()).to.eql [
        new TableItem {name: 'baz', value: 80}
        new TableItem {name: 'foo', value: 100}
        new TableItem {name: 'bar', value: 500}
      ]

    it '自身が変化していないこと', =>
      expect(@items).to.not.eql @sorted

  describe '#pagenatedBy', =>
    beforeEach =>
      @pagenated = @items.pagenatedBy 1, 2

    it '返却値が正しいこと', =>
      expect(@pagenated.getItems()).to.eql [
        new TableItem {name: 'foo', value: 100}
        new TableItem {name: 'bar', value: 500}
      ]

    it '自身が変化していないこと', =>
      expect(@items).to.not.eql @pagenated

  describe '#filteredBy', =>
    beforeEach =>
      @filtered = @items.filteredBy
        term: 'a'
        column: 'value'
        order: 'desc'
        page: 1
        per: 1

    it '返却値が正しいこと', =>
      expect(@filtered.getItems()).to.eql [
        new TableItem {name: 'bar', value: 500}
      ]

    it '自身が変化していないこと', =>
      expect(@items).to.not.eql @filtered

