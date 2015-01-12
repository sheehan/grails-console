App.module 'Util', (Util, App, Backbone, Marionette, $, _) ->

  Util.snakeToCamel = (s) -> s.replace(/(\_\w)/g, (m) -> m[1].toUpperCase())

  Util.padRight = (s, length, padChar = ' ') ->
    while s.length < length
      s = s + padChar
    s