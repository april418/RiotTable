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
    "{#{("#{k}: #{v}" for k, v of @ when /Function/.test Object::toString.call(v)).join ','}}"

  keys: ->
    Object.keys @

  values: ->
    (v for k, v of @)

  each: (block) ->
    for k, v of @
      block k, v

  map: (block) ->
    (block k, v for k, v of @)

  all: (block) ->
    for k, v of @
      unless block k, v
        return false
    true

  any: (block) ->
    for k, v of @
      if block k, v
        return true
    false

  match: (term) ->
    @any (k, v) ->
      # exclude function
      return false if /Function/.test Object::toString.call(v)
      new RegExp(RegExp.escape term).test v


module.exports = BaseObject

