BaseObject = require './base-object.coffee'
CONSTANTS = require './constants.coffee'
ORDER = CONSTANTS.ORDER
ORDER_VALUES = CONSTANTS.ORDER_VALUES


class TableColumn extends BaseObject
  @INITIAL_STATE:
    key: null
    label: null
    sortable: true
    order: null

  constructor: (header = {}) ->
    Object.assign @, TableColumn.INITIAL_STATE, header

  clone: ->
    Object.assign new TableColumn(), @

  getLabel: ->
    @label

  getKey: ->
    @key

  getOrder: ->
    @order

  setOrder: (order) ->
    return if ORDER_VALUES.indexOf(order) is -1
    @order = order

  resetOrder: ->
    @order = TableColumn.INITIAL_STATE.order

  isSortable: ->
    @sortable

  isOrderAsc: ->
    @isSortable() and @order is ORDER.ASC

  isOrderDesc: ->
    @isSortable() and @order is ORDER.DESC

  isOrderDefault: ->
    @isSortable() and @order is TableColumn.INITIAL_STATE.order


module.exports = TableColumn

