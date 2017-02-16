RegExp.escape = (string) ->
  string.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'


class BaseObject extends Object
  constructor: (object = {}) ->
    Object.assign @, object

  clone: ->
    Object.assign new BaseObject(), @

  toObject: ->
    Object.assign {}, @

  toString: ->
    "{#{@map((k, v) -> "#{k}: #{v}").join ','}}"

  keys: ->
    Object.keys @

  values: ->
    (@[k] for k in @keys())

  each: (block) ->
    for k in @keys()
      block k, @[k]

  map: (block) ->
    results = []
    @each (k, v) ->
      results.push block k, v
    results

  all: (block) ->
    for k in @keys()
      unless block k, @[k]
        return false
    true

  any: (block) ->
    for k in @keys()
      if block k, @[k]
        return true
    false

  match: (term) ->
    @any (k, v) ->
      # exclude function
      return false if /Function/.test Object::toString.call(v)
      new RegExp(RegExp.escape term).test v


module.exports = BaseObject

