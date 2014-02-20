App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  Entities.FileCollection = Backbone.Collection.extend

    model: (attrs, options) ->
      file = new Entities.File attrs, options
      file.store = options.collection.store
      file

    comparator: (file) -> file.get('type') + file.get('name')

    store: 'local'

    path: '/'

    fetchByStoreAndPath: (@store, @path) ->
      @trigger 'fetching'
      @fetch reset: true

    up: ->
      @fetchByStoreAndPath @store, @getParent()

    getParent: ->
      App.Util.Path.getParent @path

    hasParent: ->
      App.Util.Path.hasParent @path

    getCurrentDir: ->
      App.Util.Path.getCurrentDir @path

    getNormalizedPath: ->
      App.Util.Path.getNormalized @path

    sync: (method, collection, options) ->
      App.getFileStoreByName(@store).syncCollection method, collection, options

    parse: (response, options) ->
      App.getFileStoreByName(@store).parseCollection @, response, options
