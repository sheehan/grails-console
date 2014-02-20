App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->

  Result.ResultCollectionView = Marionette.CompositeView.extend
  
    template: 'result/results'

    itemViewContainer: '.inner'

    events:
      'click .clear': 'onClearClick'

    getItemView: (item) -> Result.ResultView

    onAfterItemAdded: (itemView) ->
      @scrollToResultView itemView

    initialize: ->
      @listenTo App.settings, 'change:results.wrapText', @setWrap
      @listenTo @, 'itemview:complete', @scrollToResultView

    scrollToResultView: (resultView) ->
      scroll = resultView.$el.position().top + @$('.script-result-section').scrollTop()
      @$('.script-result-section').animate scrollTop: scroll

    setWrap: ->
      @$('.script-result-section').toggleClass 'wrap', App.settings.get('results.wrapText')

    onRender: ->
      @setWrap()

    onClearClick: (event) ->
      event.preventDefault()
      App.execute 'clear'