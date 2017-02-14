riot-table
  h3.center-align(if="{ title? }")
    | { title }

  header.table-nav-header
    nav
      div.nav-wrapper
        form
          div.input-field
            input#table-searcher(type="search" onInput="{ handleInput }")
            label.label-icon(for="table-searcher")
              i.material-icons search
            i.material-icons close

  div(if="{ not store.isLoading() and not store.hasItem() }")
    p record not found.

  preloader(if="{ store.isLoading() }")

  table.table-header.centered.highlight(if="{ not store.isLoading() and store.hasItem() }")
    thead
      tr
        th(each="{^ column in store.getColumns() }"
          class="{^ sortable: column.isSortable() }"
          onClick="{ handleClickHeader }")
          | { column.getLabel() }
          i.tiny.material-icons(if="{ column.isOrderDefault() }") swap_vert
          i.tiny.material-icons(if="{ column.isOrderAsc() }") keyboard_arrow_up
          i.tiny.material-icons(if="{ column.isOrderDesc() }") keyboard_arrow_down

  div.table-content(if="{ not store.isLoading() and store.hasItem() }" onResize="{ handleResize }")
    table.table-body.centered.highlight
      //- dummy header for fix width (display: none)
      thead
        tr
          th(each="{^ column in store.getColumns() }")
            | { column.getLabel() }
            i.tiny.material-icons(if="{ column.isSortable() }") swap_vert
      tbody
        tr(each="{^ item in store.getItems() }"
          onClick="{ handleClickRow }"
          onMouseOver="{ handleMouseOverRow }")
          td(each="{^ column in store.getColumns() }")
            | { item.getValue(column.getKey()) }

  footer.table-nav-footer(if="{ not store.isLoading() and store.canPagenate() }")
    div.center-align
      ul.pagination
        li(class="{^ waves-effect: !store.isFirstPage(), disabled: store.isFirstPage() }"
          onClick="{ handleClickPreviousPage }")
          a: i.material-icons chevron_left
        li(each="{^ page in store.getPageIterator() }"
          class="{^ waves-effect: !store.isCurrentPage(page), active: store.isCurrentPage(page) }")
          a(onClick="{ handleClickPager }")
            | { page }
        li(class="{^ waves-effect: !store.isLastPage(), disabled: store.isLastPage() }"
          onClick="{ handleClickNextPage }")
          a: i.material-icons chevron_right

  script.
    require './preloader.tag'
    # manage table state
    TableStore = require '../coffeescripts/table-store.coffee'
    TableAction = require '../coffeescripts/table-action.coffee'
    TableDispatcher = require '../coffeescripts/table-dispatcher.coffee'

    # ========================================
    #   instance variables
    # ========================================
    @title = opts.title
    @store = new TableStore
      header: opts.header
      items: opts.items
    @dispatcher = new TableDispatcher(@store)
    @onClickRow = opts.onClickRow
    @onMouseOverRow = opts.onMouseOverRow
    @debug = opts.debug ? false

    # ========================================
    #   event handlers
    # ========================================
    @handleInput = (event) =>
      term = event.target?.value
      if @debug
        console.log 'Input fired KeyUp event.'
        console.log term
      @dispatcher.dispatch new TableAction 'search', term

    @handleClickHeader = (event) =>
      column = event.item?.column
      if @debug
        console.log 'Header fired Click event.'
        console.log column
      @dispatcher.dispatch new TableAction 'sort', column

    @handleClickRow = (event) =>
      item = event.item?.item
      if @debug
        console.log 'Row fired Click event.'
        console.log item
      @onClickRow item if @onClickRow?

    @handleMouseOverRow = (event) =>
      item = event.item?.item
      if @debug
        console.log 'Row fired MouseOver event.'
        console.log item
      @onMouseOverRow item if @onMouseOverRow?

    @handleClickNextPage = (event) =>
      console.log 'Next page fired Click event.' if @debug
      @dispatcher.dispatch new TableAction 'moveToNextPage'

    @handleClickPreviousPage = (event) =>
      console.log 'Previous page fired Click event.' if @debug
      @dispatcher.dispatch new TableAction 'moveToPreviousPage'

    @handleClickPager = (event) =>
      page = event.item?.page
      if @debug
        console.log 'Pager fired Click event.'
        console.log page
      @dispatcher.dispatch new TableAction 'moveTo', page

