describe 'BaseObject', ->
  object = null

  beforeEach ->
    object = new BaseObject
      hoge: 'huga'
      foo: 'bar'
      baz: 5

  describe '#clone', ->
    beforeEach ->
      clone = object.clone()

    it '自分自身と同値であること', ->
      expect(clone).to.eql object

    it 'クローンを変更しても自身が変更されないこと', ->
      clone.foo = 'bom'
      expect(clone).to.not.eql object

  describe '#toObject', ->
    it 'pending...'

  describe '#toString', ->
    it 'pending...'

  describe '#keys', ->
    it 'pending...'

  describe '#values', ->
    it 'pending...'

  describe '#each', ->
    it 'pending...'

  describe '#map', ->
    it 'pending...'

  describe '#all', ->
    it 'pending...'

  describe '#any', ->
    it 'pending...'

  describe '#match', ->
    it 'pending...'

