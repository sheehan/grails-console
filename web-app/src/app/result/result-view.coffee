App.module 'Result', (Editor, App, Backbone, Marionette, $, _) ->

  Editor.ResultView = Marionette.ItemView.extend
  
    template: 'result/result'

    attributes:
      class: 'script-result'

    modelEvents:
      change: 'render'

    onRender: ->
      unless @model.get('loading')
        @$el.addClass 'stacktrace' unless @model.isSuccess()
        @trigger 'complete'

    serializeData: ->
      json = @model.toJSON()
      json.result = @model.get('exception')?.stackTrace or @model.get('error') or @model.get('result')
      json.inputGutter = '<'
      json.inputLines = @model.get('input').match /[^\r\n]+/g
      json