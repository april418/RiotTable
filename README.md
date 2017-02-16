# RiotTable
## TODO
- test code
- add undo / redo
- fix bugs

## はまったことの共有
- 何故か2回コンパイルされる
 - package.jsonにbrowserifyフィールドを書いたなら、
karma.conf.coffeeには書かなくていい(むしろ書いちゃダメ)。
参考→ https://github.com/atomify/atomify/issues/62

- RSpecのletみたいに書きたいなら
 - it's not working.
```coffee
describe 'Animal', ->
  beforeEach -> @animal = new Animal @kind

  context 'kind of cow', ->
    before -> @kind = 'cow'
    it 'voice should eq "moo"', ->
      @animal.voice().should.eq 'moo'

    context 'kind of cat', ->
      before -> @kind = 'cat'
      it 'voice should eq "meow"', ->
        @animal.voice().should.eq 'meow'

    context 'kind of fish', ->
      before -> @kind = 'fish'
      it 'voice cant be heared', ->
        (=> @animal.voice()).should.throw 'fish voice cant be heared'
```
 - work it!
```coffee
describe 'Animal', ->
  beforeEach => @animal = new Animal @kind

  context 'kind of cow', =>
    before => @kind = 'cow'
    it 'voice should eq "moo"', =>
      @animal.voice().should.eq 'moo'

    context 'kind of cat', =>
      before => @kind = 'cat'
      it 'voice should eq "meow"', =>
        @animal.voice().should.eq 'meow'

    context 'kind of fish', =>
      before => @kind = 'fish'
      it 'voice cant be heared', =>
        (=> @animal.voice()).should.throw 'fish voice cant be heared'
```
参考→https://github.com/mochajs/mocha/issues/971#issuecomment-27387614

