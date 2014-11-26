App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->

  Result.ResultCollectionView = Marionette.CompositeView.extend

    template: 'result/results'

    itemViewContainer: '.inner'

    events:
      'click .clear': 'onClearClick'
      'submit .prompt-form': 'onPromptSubmit'

    getItemView: (item) -> Result.ResultView

    onAfterItemAdded: (itemView) ->
      @scrollToResultView itemView

    initialize: ->
      @listenTo App.settings, 'change:results.wrapText', @setWrap
      @listenTo App.settings, 'change:results.showInput', @setShowInput
      @listenTo @, 'itemview:complete', @scrollToResultView

    scrollToResultView: (resultView) ->
      scroll = resultView.$el.position().top + resultView.$el.height() + @$('.script-result-section').scrollTop()
      @$('.script-result-section').animate scrollTop: scroll

    setWrap: ->
      @$('.script-result-section').toggleClass 'wrap', App.settings.get('results.wrapText')

    setShowInput: ->
      @$('.script-result-section').toggleClass 'hide-input', !App.settings.get('results.showInput')

    onRender: ->
      @setWrap()
      @setShowInput()

      @$('.prompt').bind 'keydown', 'Shift+return return', (event) => @onExecute(event)
      @$('.prompt').bind 'keyup', 'up', (event) => @onUpKeyPress(event)
      @$('.prompt').bind 'keyup', 'down', (event) => @onDownKeyPress(event)

    onClearClick: (event) ->
      event.preventDefault()
      App.execute 'clear'

    onUpKeyPress: (event) ->
      @trigger 'upKeyPress'

    onDownKeyPress: (event) ->
      @trigger 'downKeyPress'

    setPromptText: (text) ->
      @$('.prompt').val text
      prompt = @$('.prompt')[0]
      prompt.setSelectionRange(text.length, text.length) if text

    onExecute: (event) ->
      input = @$('.prompt').val()
      if input
        if not event.shiftKey
          @trigger 'execute', input.trim()
          @$('.prompt').val ''

        @$('.prompt').css 'overflow', 'hidden'
        @$('.prompt').height 0
        @$('.prompt').height @$('.prompt')[0].scrollHeight