App.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  localStorageKey = 'gconsole.settings'

  Entities.Settings = Backbone.Model.extend

    defaults:
      'orientation': 'vertical'
      'layout.west.size': 250
      'layout.east.size': '50%'
      'layout.south.size': '50%'
      'results.wrapText': true
      'results.showInput': true
      'editor.autoImportDomains': false
      'editor.warnBeforeExit': true
      'theme': 'default'

    toggle: (attribute) ->
      @set attribute, not @get(attribute)

    save: ->
      localStorage.setItem localStorageKey, JSON.stringify(this)

    load: ->
      json = JSON.parse(localStorage.getItem(localStorageKey)) or {}
      @set json

  instance = undefined

  App.reqres.setHandler 'settings:entity', ->
    unless instance
      instance = new Entities.Settings
      instance.load()
    instance