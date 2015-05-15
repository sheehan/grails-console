App.module 'Main', (Main, App, Backbone, Marionette, $, _) ->

  Main.HeaderView = Backbone.Marionette.ItemView.extend

    template: 'main/header'

    attributes:
      class: 'navbar navbar-fixed-top'

    initialize: ->
      @listenTo App, 'file:show', @onFileShow

    onFileShow: (file) ->
      name = file.get('name')
      if name
        @$('.title span').html(name).show()
      else
        @$('.title span').hide()

    onRender: ->
      @settingsView = new Main.SettingsView(model: App.settings)
      @$('.settings-btn-group').append @settingsView.render().$el
      @settingsView.render()

    onClose: ->
      @settingsView.close()