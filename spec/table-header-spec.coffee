describe 'TableHeader', ->
  TableHeader = require '../src/coffeescripts/table-header.coffee'
  TableColumn = require '../src/coffeescripts/table-column.coffee'

  beforeEach =>
    @header = new TableHeader [
      {key: 'foo', label: 'ふー', sortable: false}
      {key: 'bar', label: 'ばー', order: 'asc'}
      {key: 'baz', label: 'ばず'}
    ]

  describe '#constructor', =>
    it 'orderが複数設定されていたらエラーになること', =>
      expect(-> new TableHeader [
        {key: 'foo', label: 'ふー', order: 'desc'}
        {key: 'bar', label: 'ばー', order: 'asc'}
      ]).to.throw TableHeader.MultipleOrderColumnError

  describe '#clone', =>
    beforeEach =>
      @clone = @header.clone()

    it '自身とクローンが同値であること', =>
      expect(@clone).to.eql @header

    it 'クローンが変更されても自身は変更されないこと', =>
      @clone.findColumn('foo').label = 'ふう'
      expect(@clone).to.not.eql @header

  describe '#addNewColumn', =>
    it '新しい列が追加されていること', =>
      @header.addNewColumn {key: 'bom', label: 'ぼむ'}
      expect(@header.getColumns()).to.include new TableColumn {key: 'bom', label: 'ぼむ'}

  describe '#initializeHeader', =>
    it '正しく値がセットされていること', =>
      @header = new TableHeader()
      @header.initializeHeader [
        {key: 'baz', label: 'ばず'}
      ]
      expect(@header.getColumns()).to.eql [
        new TableColumn {key: 'baz', label: 'ばず'}
      ]

  describe '#findColumn', =>
    it '返却値が正しいこと', =>
      expect(@header.findColumn 'foo').to.eql new TableColumn {key: 'foo', label: 'ふー', sortable: false}

  describe '#findOrderColumn', =>
    it '返却値が正しいこと', =>
      expect(@header.findOrderColumn()).to.eql new TableColumn {key: 'bar', label: 'ばー', order: 'asc'}

  describe '#setOrder', =>
    it '値がセットされていること', =>
      @header.setOrder 'bar', 'desc'
      expect(@header.getOrder 'bar').to.equal 'desc'

  describe '#getOrder', =>
    it '返却値が正しいこと', =>
      expect(@header.getOrder 'bar').to.equal 'asc'

  describe '#getColumns', =>
    it '@columnsと返却値が等しいこと', =>
      expect(@header.getColumns()).to.eql @header.columns

  describe '#validateMultipleOrder', =>
    it 'pending...'

