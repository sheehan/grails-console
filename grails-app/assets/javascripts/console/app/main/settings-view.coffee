App.module 'Main', (Main, App, Backbone, Marionette, $, _) ->

  Main.SettingsView = Backbone.Marionette.ItemView.extend

    template: 'main/settings'

    events:
      'click .setting': 'onSettingClick'
      'click .help': 'onHelpClick'

    tagName: 'ul'

    attributes:
      'class': 'dropdown-menu pull-right settings'
      'role': 'menu'

    initialize: ->
      @listenTo @model, 'change', @render

    onRender: ->
      @$('.orientation-horizontal').toggleClass 'selected', @model.get('orientation') is 'horizontal'
      @$('.orientation-vertical').toggleClass 'selected', @model.get('orientation') is 'vertical'
      @$('.results-wrap').toggleClass 'selected', @model.get('results.wrapText')
      @$('.show-input').toggleClass 'selected', @model.get('results.showInput')
      @$('.auto-import-domains').toggleClass 'selected', @model.get('editor.autoImportDomains')
      @$('.warn-before-exit').toggleClass 'selected', @model.get('editor.warnBeforeExit')
      @$('.theme').each (index, el) =>
        $el = $(el)
        $el.toggleClass 'selected', @model.get('theme') is $el.data('theme')

    onSettingClick: (event) ->
      event.preventDefault()
      event.stopPropagation()
      $el = $(event.currentTarget)
      switch
        when $el.is '.orientation-horizontal' then @model.set 'orientation', 'horizontal'
        when $el.is '.orientation-vertical'   then @model.set 'orientation', 'vertical'
        when $el.is '.results-wrap'           then @model.toggle 'results.wrapText'
        when $el.is '.show-input'             then @model.toggle 'results.showInput'
        when $el.is '.auto-import-domains'    then @model.toggle 'editor.autoImportDomains'
        when $el.is '.warn-before-exit'       then @model.toggle 'editor.warnBeforeExit'
        when $el.is '.theme'                  then @model.set 'theme', $el.data('theme')
      @model.save()

    onHelpClick: (event) ->
      event.preventDefault()
      App.execute 'help'