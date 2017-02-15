BaseObject = require './base-object.coffee'


class TableItem extends BaseObject
  clone: ->
    Object.assign new TableItem(), @

  getValue: (key) ->
    @[key]


module.exports = TableItem

