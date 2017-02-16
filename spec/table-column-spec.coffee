describe 'TableColumn', ->
  TableColumn = require '../src/coffeescripts/table-column.coffee'
  CONSTANTS = require '../src/coffeescripts/constants.coffee'
  ORDER = CONSTANTS.ORDER
  ORDER_VALUES = CONSTANTS.ORDER_VALUES

  beforeEach =>
    @column = new TableColumn
      key: 'hoge'
      label: 'ほげ'
      sortable: false
      order: ORDER.DESC

  describe '#constructor', ->
    it 'pending...'

  describe '#clone', =>
    beforeEach =>
      @clone = @column.clone()

    it '自身とクローンが同値であること', =>
      expect(@clone).to.eql @column

    it 'クローンを変更しても自身が変更されないこと', =>
      @clone.key = 'huga'
      expect(@clone).to.not.eql @column

  describe '#getLabel', =>
    it '@labelと返却値が等しいこと', =>
      expect(@column.getLabel()).to.equal @column.label

  describe '#getKey', =>
    it '@keyと返却値が等しいこと', =>
      expect(@column.getKey()).to.equal @column.key

  describe '#getOrder', =>
    it '@orderと返却値が等しいこと', =>
      expect(@column.getOrder()).to.equal @column.order

  describe '#setOrder', =>
    beforeEach =>
      @column.setOrder @order

    context '入力値がORDER_VALUESに含まれるとき', =>
      before =>
        @order = ORDER.ASC

      it '返却値が入力値と等しいこと', =>
        expect(@column.getOrder()).to.equal @order

    context '入力値がORDER_VALUESに含まれないとき', =>
      before =>
        @order = 'foo'

      it '返却値が元々の値であること(変化していないこと)', =>
        expect(@column.getOrder()).to.equal ORDER.DESC

  describe '#resetOrder', =>
    it '返却値がTableColumn.INITIAL_STATE.orderと等しいこと', =>
      @column.resetOrder()
      expect(@column.getOrder()).to.equal TableColumn.INITIAL_STATE.order

  describe 'isSortable', =>
    it '@sortableの値と等しいこと', =>
      expect(@column.isSortable()).to.be.false

  describe 'isOrderAsc', =>
    beforeEach =>
      @column.sortable = @sortable
      @column.order = @order

    context '@sortableがtrueかつ', =>
      before =>
        @sortable = true

      context '@orderがTableColumn.INITIAL_STATE.orderのとき', =>
        before =>
          @order = TableColumn.INITIAL_STATE.order

        it '返却値がfalseになること', =>
          expect(@column.isOrderAsc()).to.be.false

      context '@orderがORDER.ASCのとき', =>
        before =>
          @order = ORDER.ASC

        it '返却値がtrueになること', =>
          expect(@column.isOrderAsc()).to.be.true

      context '@orderがORDER.DESCのとき', =>
        before =>
          @order = ORDER.DESC

        it '返却値がfalseになること', =>
          expect(@column.isOrderAsc()).to.be.false

    context '@sortableがfalseのかつ', =>
      before =>
        @sortable = false

      context '@orderがTableColumn.INITIAL_STATE.orderのとき', =>
        before =>
          @order = TableColumn.INITIAL_STATE.order

        it '返却値がfalseになること', =>
          expect(@column.isOrderAsc()).to.be.false

      context '@orderがORDER.ASCのとき', =>
        before =>
          @order = ORDER.ASC

        it '返却値がtrueになること', =>
          expect(@column.isOrderAsc()).to.be.false

      context '@orderがORDER.DESCのとき', =>
        before =>
          @order = ORDER.DESC

        it '返却値がfalseになること', =>
          expect(@column.isOrderAsc()).to.be.false

  describe 'isOrderDesc', =>
    beforeEach =>
      @column.sortable = @sortable
      @column.order = @order

    context '@sortableがtrueかつ', =>
      before =>
        @sortable = true

      context '@orderがTableColumn.INITIAL_STATE.orderのとき', =>
        before =>
          @order = TableColumn.INITIAL_STATE.order

        it '返却値がfalseになること', =>
          expect(@column.isOrderDesc()).to.be.false

      context '@orderがORDER.ASCのとき', =>
        before =>
          @order = ORDER.ASC

        it '返却値がfalseになること', =>
          expect(@column.isOrderDesc()).to.be.false

      context '@orderがORDER.DESCのとき', =>
        before =>
          @order = ORDER.DESC

        it '返却値がtrueになること', =>
          expect(@column.isOrderDesc()).to.be.true

    context '@sortableがfalseのかつ', =>
      before =>
        @sortable = false

      context '@orderがTableColumn.INITIAL_STATE.orderのとき', =>
        before =>
          @order = TableColumn.INITIAL_STATE.order

        it '返却値がfalseになること', =>
          expect(@column.isOrderDesc()).to.be.false

      context '@orderがORDER.ASCのとき', =>
        before =>
          @order = ORDER.ASC

        it '返却値がtrueになること', =>
          expect(@column.isOrderDesc()).to.be.false

      context '@orderがORDER.DESCのとき', =>
        before =>
          @order = ORDER.DESC

        it '返却値がfalseになること', =>
          expect(@column.isOrderDesc()).to.be.false

  describe 'isOrderDefault', =>
    beforeEach =>
      @column.sortable = @sortable
      @column.order = @order

    context '@sortableがtrueかつ', =>
      before =>
        @sortable = true

      context '@orderがTableColumn.INITIAL_STATE.orderのとき', =>
        before =>
          @order = TableColumn.INITIAL_STATE.order

        it '返却値がtrueになること', =>
          expect(@column.isOrderDefault()).to.be.true

      context '@orderがORDER.ASCのとき', =>
        before =>
          @order = ORDER.ASC

        it '返却値がfalseになること', =>
          expect(@column.isOrderDefault()).to.be.false

      context '@orderがORDER.DESCのとき', =>
        before =>
          @order = ORDER.DESC

        it '返却値がfalseになること', =>
          expect(@column.isOrderDefault()).to.be.false

    context '@sortableがfalseのかつ', =>
      before =>
        @sortable = false

      context '@orderがTableColumn.INITIAL_STATE.orderのとき', =>
        before =>
          @order = TableColumn.INITIAL_STATE.order

        it '返却値がfalseになること', =>
          expect(@column.isOrderDefault()).to.be.false

      context '@orderがORDER.ASCのとき', =>
        before =>
          @order = ORDER.ASC

        it '返却値がtrueになること', =>
          expect(@column.isOrderDefault()).to.be.false

      context '@orderがORDER.DESCのとき', =>
        before =>
          @order = ORDER.DESC

        it '返却値がfalseになること', =>
          expect(@column.isOrderDefault()).to.be.false

