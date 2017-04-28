App.module 'Main', (Main, App, Backbone, Marionette, $, _) ->

  Main.HelpView = Backbone.Marionette.ItemView.extend

    template: 'main/help'

    triggers:
      'click .close-it': 'close'

    className: 'full-height help-view'

    serializeData: ->
      implicitVars: App.data.implicitVars
      shortcuts: App.data.shortcuts