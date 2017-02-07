require 'materialize-css/js/materialize.js'
require '../../../src/riot-table.tag'

riot = require 'riot'

items = [
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
  {name: 'hoge', value: 3500}
  {name: 'huga', value: 500}
  {name: 'piyo', value: 4900}
  {name: 'foo', value: 10000}
  {name: 'bar', value: 50}
  {name: 'baz', value: 2000}
]

riot.mount 'riot-table',
  header: [
    {
      key: 'name'
      label: 'Name'
      sortable: false
    }
    {
      key: 'value'
      label: 'Value'
    }
  ]
  items: items

