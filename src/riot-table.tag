riot-table
  h3.center-align(if="{ title? }") { title }

  input(type="text" onKeyUp="{ handleKeyUpInput }")

  table.centered.highlight
    thead
      tr
        th(each="{^ column in store.getHeader() }" class="{^ sortable: column.isSortable() }" onClick="{ handleClickHeader }")
          | { column.getLabel() }
          i.tiny.material-icons(if="{ column.isOrderDefault() }") swap_vert
          i.tiny.material-icons(if="{ column.isOrderAsc() }") keyboard_arrow_up
          i.tiny.material-icons(if="{ column.isOrderDesc() }") keyboard_arrow_down
    tbody
      tr(each="{^ item in store.getItems() }" onClick="{ handleClickRow }" onMouseOver="{ handleMouseOverRow }")
        td(each="{^ column in store.getHeader() }") { item.getValue(column.getKey()) }

  div.center-align
    ul.pagination(if="{ store.canPagenate() }")
      li(class="{^ waves-effect: !store.isFirstPage(), disabled: store.isFirstPage() }" onClick="{ handleClickPreviousPage }")
        a: i.material-icons chevron_left
      li(each="{^ page in store.pageIterator() }" class="{^ waves-effect: !store.isCurrentPage(page), active: store.isCurrentPage(page) }")
        a(onClick="{ handleClickPager }") { page }
      li(class="{^ waves-effect: !store.isLastPage(), disabled: store.isLastPage() }" onClick="{ handleClickNextPage }")
        a: i.material-icons chevron_right

  script.
    # manage table state
    TableStore = require './table-store.coffee'

    # ========================================
    #   instance variables
    # ========================================
    @title = opts.title
    @store = new TableStore
      header: opts.header
      items: opts.items
    @onClickRow = opts.onClickRow
    @onMouseOverRow = opts.onMouseOverRow
    @debug = opts.debug ? false

    # ========================================
    #   event handlers
    # ========================================
    @handleKeyUpInput = (event) =>
      term = event.target?.value
      console.log 'Input fired KeyUp event. Inputed value is ' + term + ' .'if @debug
      @store.search term

    @handleClickHeader = (event) =>
      column = event.item?.column
      console.log 'Header fired Click event. Header column is ' + column if @debug
      @store.sort column

    @handleClickRow = (event) =>
      item = event.item?.item
      console.log 'Row fired Click event. Row data is ' + item if @debug
      @onClickRow item if @onClickRow?

    @handleMouseOverRow = (event) =>
      item = event.item?.item
      console.log 'Row fired MouseOver event. Row data is ' + item if @debug
      @onMouseOverRow item if @onMouseOverRow?

    @handleClickNextPage = (event) =>
      console.log 'Next page fired Click event.' if @debug
      @store.nextPage()

    @handleClickPreviousPage = (event) =>
      console.log 'Previous page fired Click event.' if @debug
      @store.previousPage()

    @handleClickPager = (event) =>
      page = event.item?.currentPage
      console.log 'Pager fired Click event. Page is ' + page if @debug
      @store.pagenate page

