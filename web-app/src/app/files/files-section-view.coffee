App.module 'Files', (Files, App, Backbone, Marionette, $, _) ->

  Files.FilesSectionView = Marionette.Layout.extend

    template: 'files/files-section'

    regions:
      filePathRegion: '.file-path-region'
      storeRegion: '.store'

    attributes:
      'class': 'modal-dialog files-section-view'

    events:
      'submit form.file-info': 'onSave'
      'click button.save': 'onSave'

    initialize: (options) ->
      @scriptsView = new Files.ScriptsView
        collection: @collection
        showDelete: false

      @listenTo @scriptsView, 'render', @resize
      @listenTo @scriptsView, 'file:selected', @onFileSelected

    onRender: ->
      @storeRegion.show @scriptsView

    onFileSelected: (file) ->
      @setName file.get('name')

    resize: ->
      if (@$el.is ':visible')
        modalBodyHeight = @$('.modal-content').height() - @$('.modal-header').outerHeight() - @$('.modal-footer').outerHeight()
        @$('.modal-body').height modalBodyHeight

        filesBodyHeight = modalBodyHeight - @$('.files-header').outerHeight()
        @$('.files-body').height filesBodyHeight
        @$('.files-body div.store').height filesBodyHeight
        @$('.files-body div.store .scripts').height filesBodyHeight

        filesWrapperHeight = filesBodyHeight - @$('.files-body div.store .scripts > .btn-toolbar').outerHeight() - @$('.files-body div.store .scripts > .folder').outerHeight()
        @$('.files-body div.store .scripts > .files-wrapper').height filesWrapperHeight

    onSave: (event) ->
      event.preventDefault()
      fileName = @$('input.file-name').val()

      if not fileName
        alert 'File name is required.'
      else
        store = @collection.store
        path = @collection.path
        path += '/' if path[path.length - 1] isnt '/'

        file = new App.Entities.File
          name: fileName
          path: path
          type: 'file'

        file.store = store
        @trigger 'save', file

    setName: (name) ->
      @$('input.file-name').val name