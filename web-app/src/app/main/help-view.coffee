App.module 'Main', (Main, App, Backbone, Marionette, $, _) ->

  Main.HelpView = Backbone.Marionette.ItemView.extend

    template: 'main/help-modal'

    className: 'modal-dialog'

    serializeData: ->
      implicitVars: App.data.implicitVars