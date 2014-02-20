App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->

  Result.Controller = Marionette.Controller.extend

    initialize: (options) ->
      @collection = new App.Result.ResultCollection()
      @resultsView = new App.Result.ResultCollectionView(collection: @collection)

    execute: (input) ->
      result = new App.Result.Result
        input: input

      result.execute()
      @collection.add result

    clear: ->
      @collection.reset()


