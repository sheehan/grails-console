App.module 'Editor', (Editor, App, Backbone, Marionette, $, _) ->

  Editor.Controller = Marionette.Controller.extend

    initialize: (options) ->
      $(window).on "beforeunload", (event) =>
        "You have unsaved changes." if @isDirty() and App.settings.get('editor.warnBeforeExit')

      @editorView = new Editor.EditorView()

    newFile: ->
      file = new App.Entities.File
      @showFile file

    showFile: (file) ->
      App.trigger 'file:show', file
      @file = file
      @editorView.refresh()
      @editorView.setValue file.get('text')

    save: ->
      text = @editorView.getValue()
      @file.set 'text', text
      if @file.isNew()
        App.execute 'saveAs'
      else
        App.savingOn()
        @file.save().then -> App.savingOff()

    isDirty: ->
      @file and @normalizeText(@file.get('text')) isnt @normalizeText(@editorView.getValue())

    normalizeText: (text) -> # for Windows
      text.replace /(\r\n|\r)/gm, '\n'

    getValue: -> @editorView.getValue()





