riot-table
  h3.center-align(if="{ title? }")
    | { title }

  header.table-nav-header
    nav
      div.nav-wrapper
        form
          div.input-field
            input#table-searcher(type="search" onInput="{ handleKeyUpInput }")
            label.label-icon(for="table-searcher")
              i.material-icons search
            i.material-icons close

  table.table-header.centered.highlight
    thead
      tr
        th(each="{^ column in store.getHeader() }"
          class="{^ sortable: column.isSortable() }"
          onClick="{ handleClickHeader }")
          | { column.getLabel() }
          i.tiny.material-icons(if="{ column.isOrderDefault() }") swap_vert
          i.tiny.material-icons(if="{ column.isOrderAsc() }") keyboard_arrow_up
          i.tiny.material-icons(if="{ column.isOrderDesc() }") keyboard_arrow_down

  div.table-content(onResize="{ handleResize }")
    table.table-body.centered.highlight
      thead
        tr
          th(each="{^ column in store.getHeader() }")
            | { column.getLabel() }
            //- dummy icon
            i.tiny.material-icons(if="{ column.isSortable() }") swap_vert
      tbody
        tr(each="{^ item in store.getItems() }"
          onClick="{ handleClickRow }"
          onMouseOver="{ handleMouseOverRow }")
          td(each="{^ column in store.getHeader() }")
            | { item.getValue(column.getKey()) }

  footer.table-nav-footer
    div.center-align
      ul.pagination(if="{ store.canPagenate() }")
        li(class="{^ waves-effect: !store.isFirstPage(), disabled: store.isFirstPage() }"
          onClick="{ handleClickPreviousPage }")
          a: i.material-icons chevron_left
        li(each="{^ page in store.pageIterator() }"
          class="{^ waves-effect: !store.isCurrentPage(page), active: store.isCurrentPage(page) }")
          a(onClick="{ handleClickPager }")
            | { page }
        li(class="{^ waves-effect: !store.isLastPage(), disabled: store.isLastPage() }"
          onClick="{ handleClickNextPage }")
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
      if @debug
        console.log 'Input fired KeyUp event.'
        console.log term
      @store.search term

    @handleClickHeader = (event) =>
      column = event.item?.column
      if @debug
        console.log 'Header fired Click event.'
        console.log column
      @store.sort column

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
      @store.nextPage()

    @handleClickPreviousPage = (event) =>
      console.log 'Previous page fired Click event.' if @debug
      @store.previousPage()

    @handleClickPager = (event) =>
      page = event.item?.currentPage
      if @debug
        console.log 'Pager fired Click event.'
        console.log page
      @store.pagenate page

