App.module 'Editor', (Editor, App, Backbone, Marionette, $, _) ->

  Editor.EditorView = Marionette.ItemView.extend

    template: 'editor/editor'

    events:
      'click button.execute': 'onExecuteClick'
      'click button.new': 'onNewClick'
      'click button.save': 'onSaveClick'
      'click a.save-as': 'onSaveAsClick'

    initialize: ->
      @listenTo App.settings, 'change:theme', @setTheme

    attributes:
      id: 'editor'

    onRender: ->
      @initEditor()

    initEditor: ->
      @editor = CodeMirror.fromTextArea(@$('textarea[name=code]')[0],
        matchBrackets: true
        mode: 'groovy'
        lineNumbers: true
        extraKeys:
          'Ctrl-Enter': ->  App.execute 'execute'
          'Cmd-Enter': ->   App.execute 'execute'
          'Ctrl-S': ->      App.execute 'save'
          'Cmd-S': ->       App.execute 'save'
          'Esc': ->         App.execute 'clear'
      )
      @editor.focus()
      @editor.setValue ''
      @setTheme()

    setTheme: ->
      @editor.setOption 'theme', App.settings.get('theme')

    getValue: ->
      @editor.getValue()

    refresh: ->
      @editor.refresh()

    setValue: (text) ->
      @editor.setValue text
      @editor.refresh()
      @editor.focus()

    onNewClick: (event) ->
      event.preventDefault()
      App.execute 'new'

    onSaveClick: (event) ->
      event.preventDefault()
      App.execute 'save'

    onSaveAsClick: (event) ->
      event.preventDefault()
      App.execute 'saveAs'

    onExecuteClick: (event) ->
      event.preventDefault()
      App.execute 'execute'

    onShow: ->
      @editor.focus()