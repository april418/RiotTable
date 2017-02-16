describe 'BaseObject', ->
  BaseObject = require '../src/coffeescripts/base-object.coffee'

  beforeEach =>
    @object = new BaseObject
      hoge: 'huga'
      foo: 'bar'
      baz: 5

  describe '#clone', =>
    beforeEach =>
      @clone = @object.clone()

    it '自分自身と同値であること', =>
      expect(@clone).to.eql @object

    it 'クローンを変更しても自身が変更されないこと', =>
      @clone.foo = 'bom'
      expect(@clone).to.not.eql @object

  describe '#toObject', =>
    it 'pending...'

  describe '#toString', =>
    it 'pending...'

  describe '#keys', =>
    it '返却値が正しいこと', =>
      expect(@object.keys()).to.eql ['hoge', 'foo', 'baz']

  describe '#values', =>
    it '返却値が正しいこと', =>
      expect(@object.values()).to.eql ['huga', 'bar', 5]

  describe '#each', =>
    it 'pending...'

  describe '#map', =>
    it '返却値が正しいこと', =>
      expect(@object.map (k, v) -> k).to.eql ['hoge', 'foo', 'baz']

  describe '#all', =>
    it '返却値が正しいこと', =>
      expect(@object.all (k, v) -> /String/.test Object::toString.call(v)).to.be.false

  describe '#any', =>
    it '返却値が正しいこと', =>
      expect(@object.any (k, v) -> /Number/.test Object::toString.call(v)).to.be.true

  describe '#match', =>
    it '返却値が正しいこと', =>
      expect(@object.match '5').to.be.true

