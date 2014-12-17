App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->

  Result.ResultView = Marionette.ItemView.extend
  
    template: 'result/result'

    attributes:
      class: 'script-result'

    modelEvents:
      change: 'render'

    events:
      'click .result .toggle': 'onToggleClick'

    onRender: ->
      unless @model.get('loading')
        @$el.addClass 'stacktrace' unless @model.isSuccess()
        @trigger 'complete'

    onToggleClick: (event) ->
      event.preventDefault()
      $el = $(event.currentTarget)
      $el.closest('.tree-item').toggleClass 'open'

    serializeData: ->
      json = @model.toJSON()
      json.result = @model.get('error') or @model.get('result')
      json.inputGutter = '<'
      json.inputLines = @model.get('input').match /[^\r\n]+/g

      if _.isObject(@model.get('resultTree'))
        json.resultTree = {name: json.result, children: @convertTreeNode(@model.get('resultTree'))}

      json

    convertTreeNode: (node) ->

      if _.isArray node
        result = (@convertTreeNode it for it in node)
      else if _.isObject node
        result = for k,v of node
          {name: k, value: v}
      else
        result = {name: node}

      result

  Handlebars.registerPartial 'tree', JST['result/tree']