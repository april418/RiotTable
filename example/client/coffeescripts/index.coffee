require 'materialize-css/js/materialize.js'
require('./extensions.coffee').apply window
require '../../../src/riot-table.tag'

riot = require 'riot'

items = ({name: ['hoge', 'huga', 'piyo', 'foo', 'bar', 'baz'].sample(), value: (i * 100 for i in [1...100]).sample()} for i in [1..90])

riot.mount 'riot-table',
  columns: [
    'name'
    'value'
  ]
  headers:
    name:
      label: 'Name'
      sortable: false
    value:
      label: 'Value'
      sortable: true
  items: items
  debug: true

