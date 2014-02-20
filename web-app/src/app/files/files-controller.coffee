App.module 'Files', (Files, App, Backbone, Marionette, $, _) ->

  Files.Controller = Marionette.Controller.extend

    initialize: ->
      @collection = new App.Entities.FileCollection()

      @listenTo App, 'file:created', (file) ->
        @fetchScripts file.store, file.getParent()

      @scriptsView = new Files.ScriptsView
        collection: @collection

    fetchScripts: (store, path) ->
      @collection.fetchByStoreAndPath store, path

    promptForNewFile: (store, path) ->
      dfd = $.Deferred()

      collection = new App.Entities.FileCollection()

      view = new Files.FilesSectionView
        collection: collection

      collection.fetchByStoreAndPath store, path

      App.Util.Modal.showInModal view,
        draggable: true
        resizable: true

      view.$el.find('.file-name').focus()

      view.on 'save', (file) ->
        dfd.resolveWith null, [file]
        view.close()

      view.on 'close', -> dfd.resolve()

      dfd.promise()

