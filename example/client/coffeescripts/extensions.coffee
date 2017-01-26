#
# extent this object. (e.g. window)
#
extentions = ->
  # ====================
  #   Object
  # ====================
  @Object::getType ?= ->
    Object::toString.call(@).match(/\[object (.+)\]/).second()
  @Object::is ?= (type) ->
    type? and @getType() is type
  @Object::keys ?= ->
    return [] unless @getType() is 'Object'
    Object.keys(@)
  @Object::values ?= ->
    return [] unless @getType() is 'Object'
    (v for k, v of @)
  @Object::length ?= ->
    return 0 unless @getType() is 'Object'
    @keys().length
  @Object::any ?= (block) ->
    for k, v of @
      o = {}
      o[k] = v
      if block(o)
        return true
    false
  @Object::all ?= (block) ->
    for k, v of @
      o = {}
      o[k] = v
      unless block(o)
        return false
    true
  @Object::like ?= (element) ->
    return false unless @is 'Object'
    return false unless ['String', 'Number'].includes element.getType()
    @any (i) ->
      v = i.values().first()
      return false unless ['String', 'Number'].includes v.getType()
      v.like element.toString()

  # ====================
  #   RegExp
  # ====================
  @RegExp.escape ?= (string) ->
    string.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

  # ====================
  #   Array
  # ====================
  @Array::first ?= ->
    @[0]
  @Array::second ?= ->
    @[1]
  @Array::third ?= ->
    @[2]
  @Array::last ?= ->
    @[@length - 1]
  @Array::includes ?= (element) ->
    @indexOf(element) isnt -1
  @Array::any ?= (block) ->
    for i in @
      if block(i)
        return true
    false
  @Array::all ?= (block) ->
    for i in @
      unless block(i)
        return false
    true
  @Array::select ?= (block) ->
    (i for i in @ when block i)
  @Array::like = (element) ->
    return false unless ['String', 'Number'].includes element.getType()
    @any (i) ->
      return false unless ['String', 'Number'].includes i.getType()
      i.like element.toString()
  @Array::sample ?= (number = 1) ->
    return null if @length is 0 or number < 1
    samples = (@[(Math.random() * @length).floor()] for i in [1..number])
    if number is 1 then samples.first() else samples

  # ====================
  #   String
  # ====================
  @String::isBlank ?= ->
    @length is 0
  @String::like = (element) ->
    return false unless ['String', 'Number'].includes element.getType()
    @match(new RegExp RegExp.escape element.toString())?

  # ====================
  #   Number
  # ====================
  @Number::like = (element) ->
    return false unless ['String', 'Number'].includes element.getType()
    @toString().match(new RegExp RegExp.escape element.toString())?
  @Number::round ?= ->
    Math.round @
  @Number::ceil ?= ->
    Math.ceil @
  @Number::floor ?= ->
    Math.floor @

  # return this object
  @

module.exports = extentions

