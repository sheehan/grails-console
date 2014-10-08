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
      loading: @model.get('loading')
      totalTime: @model.get('totalTime')
      input: @formattedInput()
      output: @formattedOutput()
      result: @model.get('exception')?.stackTrace or @model.get('error') or @model.get('result')

    formattedInput: ->
      @model.get('input').replace(/^/gm, '> ')

    formattedOutput: ->
      if @model.get('output') then @model.get('output').replace(/^/gm, '  ') else null