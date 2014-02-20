App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->

  Result.ResultCollection = Backbone.Collection.extend

    model: (attrs, options) -> new Result.Result attrs, options
