App.module 'Main', (Main, App, Backbone, Marionette, $, _) ->

  Main.HelpView = Backbone.Marionette.ItemView.extend

    template: 'main/help-modal'

    className: 'modal-dialog'

    serializeData: ->
      modifier: if navigator.userAgent.indexOf('Mac OS X') != -1 then 'Cmd' else 'Ctrl'
      implicitVars: App.data.implicitVars