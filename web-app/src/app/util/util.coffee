App.module 'Util', (Util, App, Backbone, Marionette, $, _) ->

  Util.snakeToCamel = (s) -> s.replace(/(\_\w)/g, (m) -> m[1].toUpperCase())