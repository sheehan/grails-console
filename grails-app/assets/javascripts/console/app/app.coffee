Marionette.Renderer.render = (template, data) ->
  JST[template] data # use compiled templates

Application = Backbone.Marionette.Application.extend

  fileStores: {}

  onInitializeBefore: (options) ->
    @data = options

    @addRegions
      headerRegion: '#header'
      mainRegion: '#main-content'

    @settings = @request 'settings:entity'
    @editorController = new App.Editor.Controller
    @filesController = new App.Files.Controller
    @resultController = new App.Result.Controller
    @router = new App.Main.Router()

    contentView = new App.Main.ContentView
      editorView: @editorController.editorView
      resultsView: @resultController.resultsView
      scriptsView: @filesController.scriptsView

    @mainRegion.show contentView
    contentView.refresh()

    @on 'file:deleted', @onFileDeleted

    @commands.setHandler 'save', @handleSave, @
    @commands.setHandler 'saveAs', @handleSaveAs, @
    @commands.setHandler 'new', @handleNew, @
    @commands.setHandler 'execute', @handleExecute, @
    @commands.setHandler 'clear', @handleClear, @
    @commands.setHandler 'help', @handleHelp, @
    @commands.setHandler 'openFile', @handleOpenFile, @
    @commands.setHandler 'showFile', @handleShowFile, @

  handleExecute: ->
    input = @editorController.getValue()
    @resultController.execute input

  handleClear: ->
    @resultController.clear()

  handleNew: ->
    if @_okToCloseCurrentFile()
      @router.showNew()
      @editorController.newFile()

  _okToCloseCurrentFile: ->
    not App.settings.get('editor.warnBeforeExit') or not @editorController.isDirty() or confirm 'Are you sure? You have unsaved changes.'

  handleSave: ->
    @editorController.save()

  handleSaveAs: ->
    text = @editorController.getValue()

    if @editorController.file.isNew()
      collection = @getActiveCollection()
      store = collection.store
      path = collection.path
    else
      file = @getActiveFile()
      store = file.store
      path = file.getParent()

    @filesController.promptForNewFile(store, path).done (file) =>
      if file
        file.set 'text', text

        @savingOn()
        file.save().then =>
          @savingOff()
          @editorController.showFile file
          @router.showFile file
          @trigger 'file:created', file

  getActiveFile: -> @editorController.file

  getActiveCollection: -> @filesController.collection

  handleHelp:->
    view = new App.Main.HelpView
    App.Util.Modal.showInModal view, draggable: true

  handleOpenFile: (store, name) ->
    dfd = App.request 'file:entity', store, name
    dfd.done (file) =>
      if file.isDirectory()
        @filesController.fetchScripts file.store, file.getAbsolutePath()
        @editorController.newFile()
      else
        @filesController.fetchScripts file.store, file.getParent()
        @editorController.showFile file
    dfd.fail (error) =>
      alert error
      @editorController.newFile()

  handleShowFile: (file) ->
    if @_okToCloseCurrentFile()
      file.fetch().done =>
        @editorController.showFile file
        @router.showFile file

  onFileDeleted: (file) ->
    if @getActiveFile().id is file.id
      @router.showNew()
      @editorController.newFile()

  onStart: (data) ->
    @headerRegion.show new App.Main.HeaderView

    @_initKeybindings()

    @showTheme()
    @settings.on 'change:theme', @showTheme, this

    Backbone.history.start(pushState: false) if Backbone?.history
    $('body').css 'visibility', 'visible'

  _initKeybindings: ->
    $(document).bind 'keydown', 'Ctrl+return Meta+return', => @execute 'execute'
    $(document).bind 'keydown', 'Ctrl+s Meta+s', (event) =>
      event.preventDefault()
      event.stopPropagation()
      @execute 'save'
    $(document).bind 'keydown', 'esc', => @execute 'clear'

  createLink: (action, params) ->
    link = "#{@data.baseUrl}/#{action}"
    link += '?' + $.param(params, true) if params
    link

  showTheme: ->
    theme = @settings.get('theme')
    $('body').attr 'data-theme', theme

  savingOn: ->
    $('.navbar .saving').fadeIn 100

  savingOff: ->
    $('.navbar .saving').fadeOut 100

  addFileStore: (fileStore) ->
    @fileStores[fileStore.storeName] = fileStore

  getFileStoreByName: (storeName) ->
    @fileStores[storeName]

  getAllFileStores: ->
    _.values @fileStores

  removeFileStore: (fileStore) ->
    delete @fileStores[fileStore.storeName]

window.App = new Application()