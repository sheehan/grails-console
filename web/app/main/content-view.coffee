App.module 'Main', (Main, App, Backbone, Marionette, $, _) ->

  Main.ContentView = Backbone.Marionette.Layout.extend

    template: 'main/content'

    attributes:
      class: 'full-height'

    regions:
      centerRegion: '.center'
      westRegion: '.outer-west'

    initialize: (options) ->
      @listenTo App.settings, 'change:orientation', @updateInnerLayout
      @listenTo App.settings, 'change:results.showPane', @updateInnerLayout
      @listenTo App.settings, 'change:layout.west.isClosed', @updateOuterLayout

      @editorView = options.editorView
      @resultsView = options.resultsView
      @scriptsView = options.scriptsView

      @listenTo @editorView, 'render', => @layout.initContent 'center'
      @listenTo @scriptsView, 'render', => @layoutOuter.initContent 'west'


    onRender: ->
      @initLayout()

      @centerRegion.show @editorView
      @westRegion.show @scriptsView

      @resultsView.render()

      @updateInnerLayout()

    refresh: ->
      @editorView.refresh()
      @layoutOuter.resizeAll()
      @layout.resizeAll()
      @updateInnerLayout()

    initLayout: ->
      @layoutOuter = @$el.layout
        center__paneSelector: '.outer-center'
        west__paneSelector: '.outer-west'
        west__contentSelector: '.files-wrapper'
        west__size: App.settings.get('layout.west.size')
        west__initClosed: App.settings.get('layout.west.isClosed')
        west__spacing_closed: 0
        west__togglerLength_open: 0
        west__togglerLength_closed: 0
        west__onresize_end: (name, $el, state, opts) ->
          App.settings.set 'layout.west.size', state.size
          App.settings.save()
        west__resizerCursor: 'ew-resize'
        resizable: true
        findNestedContent: true
        fxName: ''
        spacing_open: 3
        spacing_closed: 3
        slidable: false
        enableCursorHotkey: false

      @layout = @$('.outer-center').layout
        center__paneSelector: '.center'
        center__contentSelector: '#code-wrapper'
        center__onresize: => @editorView.refresh()
        east__paneSelector: '.east'
        east__contentSelector: '.script-result-section'
        east__initHidden: App.settings.get('orientation') isnt 'vertical' or not App.settings.get 'results.showPane'
        east__size: App.settings.get('layout.east.size')
        east__onresize_end: (name, $el, state, opts) ->
          App.settings.set 'layout.east.size', state.size
          App.settings.save()
        east__resizerCursor: 'ew-resize'
        east__spacing_closed: 0
        south__paneSelector: '.south'
        south__contentSelector: '.script-result-section'
        south__initHidden: App.settings.get('orientation') isnt 'horizontal' or not App.settings.get 'results.showPane'
        south__size: App.settings.get('layout.south.size')
        south__onresize_end: (name, $el, state, opts) ->
          App.settings.set 'layout.south.size', state.size
          App.settings.save()
        south__resizerCursor: 'ns-resize'
        south__spacing_closed: 0
        resizable: true
        closable: true
        findNestedContent: true
        fxName: ''
        spacing_open: 3
        spacing_closed: 3
        slidable: false
        enableCursorHotkey: false
        togglerLength_open: 0
        togglerLength_closed: 0

    toggleScripts: ->
      App.settings.set 'layout.west.isClosed', not @layoutOuter.state['west'].isClosed
      App.settings.save()
      @updateOuterLayout()

    updateOuterLayout: ->
      if App.settings.get 'layout.west.isClosed'
        @layoutOuter.hide 'west'
      else
        @layoutOuter.hide 'west'
        @layoutOuter.show 'west'

    toggleResults: ->
      App.settings.set 'results.showPane', not App.settings.get('results.showPane')
      App.settings.save()
      @updateInnerLayout()

    updateInnerLayout: ->
      if not App.settings.get 'results.showPane'
        @layout.hide 'south'
        @layout.hide 'east'
        return

      orientation = App.settings.get('orientation')
      if orientation is 'vertical'
        @$('.east').append @resultsView.el
        @layout.hide 'south'
        @layout.show 'east'
        @layout.initContent 'east'
      else
        @$('.south').append @resultsView.el
        @layout.hide 'east'
        @layout.show 'south'
        @layout.initContent 'south'
      @editorView.refresh()
