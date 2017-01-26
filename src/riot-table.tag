riot-table
  h3.center-align(if="{ title? }") { title }

  input(type="text" onKeyUp="{ handleKeyUpInput }")

  table.centered.highlight
    thead
      tr
        th(each="{^ column in columns }" class="{^ sortable: isSortable(column) }" onClick="{ handleClickHeader }")
          | { getLabelBy(column) }
          i.tiny.material-icons(if="{ isSortable(column) and not isOrderAsc(column) and not isOrderDesc(column) }") swap_vert
          i.tiny.material-icons(if="{ isOrderAsc(column) }") keyboard_arrow_up
          i.tiny.material-icons(if="{ isOrderDesc(column) }") keyboard_arrow_down
    tbody
      tr(each="{^ item in showItems }" onClick="{ handleClickRow }" onMouseOver="{ handleMouseOverRow }")
        td(each="{^ column in columns }") { item[column] }

  div.center-align
    ul.pagination(if="{ showPager() }")
      li(class="{^ waves-effect: !isFirstPage(), disabled: isFirstPage() }" onClick="{ handleClickPreviousPage }")
        a: i.material-icons chevron_left
      li(each="{^ currentPage in pageIterator() }" class="{^ waves-effect: !isActivePage(currentPage), active: isActivePage(currentPage) }")
        a(onClick="{ handleClickPager }") { currentPage }
      li(class="{^ waves-effect: !isLastPage(), disabled: isLastPage() }" onClick="{ handleClickNextPage }")
        a: i.material-icons chevron_right

  script.
    # include built-in objects extentions
    require('../example/client/coffeescripts/extensions.coffee').apply window

    # include XMLHttpRequest module like jQuery.ajax()
    XHR = require './xhr.coffee'

    # ========================================
    #   instance variables
    # ========================================
    @title = opts.title
    @columns = opts.columns ? []
    @headers = opts.headers ? []
    @items = opts.items ? []
    @showItems = @items
    @url = opts.url
    @convertParams = opts.paramsConverter ? (params) -> params
    @convertResponseData = opts.responseDataConverter ? (data) -> data
    @onClickRow = opts.onClickRow
    @onMouseOverRow = opts.onMouseOverRow
    @sortColumn =  null
    @sortOrder = null
    @sorter = opts.sorter ? (items, column, order) ->
      items.sort (a, b) ->
        a = a[column]
        b = b[column]
        return 0 if a is b
        if order is 'asc'
          if a > b then 1 else -1
        else
          if a > b then -1 else 1
    @searchTerm = null
    @page = opts.page ? 1
    @per = opts.per ? 25
    @totalPages =
      try
        (@items.length / @per).ceil()
      catch
        0
    @totalCount = @items?.length ? 0
    @debug = opts.debug ? false

    # ========================================
    #   event handlers
    # ========================================
    @handleKeyUpInput = (event) =>
      term = event.target?.value
      console.log 'Input fired KeyUp event. Inputed value is ' + term + ' .'if @debug
      @search term

    @handleClickHeader = (event) =>
      column = event.item?.column
      console.log 'Header fired Click event. Header column is ' + column + ' .' if @debug
      @sort column

    @handleClickRow = (event) =>
      item = event.item?.item
      console.log 'Row fired Click event. Row data is {' + (k + ': ' + v for k, v of item when not v.is 'Function').join(', ') + '} .' if @debug
      @onClickRow item if @onClickRow?

    @handleMouseOverRow = (event) =>
      item = event.item?.item
      console.log 'Row fired MouseOver event. Row data is {' + (k + ': ' + v for k, v of item when not v.is 'Function').join(', ') + '} .' if @debug
      @onMouseOverRow item if @onMouseOverRow?

    @handleClickNextPage = (event) =>
      console.log 'Next page fired Click event.' if @debug
      @nextPage()

    @handleClickPreviousPage = (event) =>
      console.log 'Previous page fired Click event.' if @debug
      @previousPage()

    @handleClickPager = (event) =>
      page = event.item?.currentPage
      console.log 'Pager fired Click event. Page is ' + page + ' .' if @debug
      @pagenate page

    @handleAjaxError = (code, text) =>
      console.log 'Error ' + code + ' has occurred. Details: ' + text if @debug

    # ========================================
    #   instance methods
    # ========================================
    @isSortable = (column) ->
      header = @headers[column]
      return false unless header?
      header.sortable

    @isOrderAsc = (column) ->
      @sortColumn? and @sortColumn is column and @sortOrder is 'asc'

    @isOrderDesc = (column) ->
      @sortColumn? and @sortColumn is column and @sortOrder is 'desc'

    @getLabelBy = (column) ->
      header = @headers[column]
      return unless header?
      header.label

    @showPager = ->
      @totalPages > 1

    @pageIterator = ->
      if @totalPages > 0 then [1..@totalPages] else []

    @isActivePage = (currentPage) ->
      currentPage? and currentPage is @page

    @isFirstPage = ->
      @page is 1

    @isLastPage = ->
      @page is @totalPages

    @refreshTable = ->
      if @url?
        @sendRequest().then (data) =>
          convertedData = @convertResponseData data
          @showItems = convertedData.items ? []
          @page = convertedData.page ? 1
          @per = convertedData.per ? 25
          @totalPages = convertedData.totalPages ? 0
          @totalCount = convertedData.totalCount ? 0
      else
        if @debug
          console.log 'SortOrder is ' + @sortOrder + ' .'
          console.log 'SortColumn is ' + @sortColumn + ' .'
          console.log 'Page is ' + @page + ' .'
          console.log 'Per is ' + @per + ' .'
          console.log 'SearchTerm is ' + @searchTerm + ' .'
        @showItems = @items
        @searchItems()
        @sortItems()
        @pagenateItems()

    @sendRequest = ->
      xhr = new XHR
        url: @url
        data: @createParams()
      xhr.send().catch @handleAjaxError

    @createParams = ->
      @convertParams
        term: @searchTerm
        column: @sortColumn
        order: @sortOrder
        page: @page
        per: @per

    @sort = (column) ->
      return unless column? or @sortColumn?
      @sortColumn = column if column?
      return unless @isSortable(@sortColumn)
      @sortOrder = if @isOrderAsc @sortColumn then 'desc' else 'asc'
      @refreshTable()

    @search = (term) ->
      return unless term? or @searchTerm?
      @searchTerm = term if term?
      @refreshTable()

    @nextPage = ->
      return if @isLastPage()
      @pagenate(@page + 1)

    @previousPage = ->
      return if @isFirstPage()
      @pagenate(@page - 1)

    @pagenate = (page) ->
      return unless page? or @page?
      @page = page if page?
      @refreshTable()

    @searchItems = ->
      return unless @searchTerm?
      unless @searchTerm.isBlank()
        @showItems = @showItems.select (item) =>
          item.like @searchTerm
      @totalCount = @showItems.length
      @totalPages = (@totalCount / @per).ceil()
      @page = @totalPages if @page > @totalPages

    @sortItems = ->
      return unless @sortColumn?
      @showItems = @sorter @showItems, @sortColumn, @sortOrder

    @pagenateItems = ->
      return if @page < 1 or @per < 1 or @totalCount <= @per
      @showItems = @showItems[((@page - 1)* @per)..(@page * @per - 1)]

    # on mount
    @refreshTable()

