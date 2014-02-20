App.module 'Util', (Util, App, Backbone, Marionette, $, _) ->

  Util.Path =

    getTokens: (path) ->
      @getNormalized(path).split('/')

    getNormalized: (path) ->
      path = path.replace /^\s+|\s+$/gm, '' # trim
      path = path[0...-1] if path[-1..] is '/'
      path

    getParent: (path) ->
      tokens = @getTokens path
      parent = null
      if tokens.length > 1
        parent = tokens[0...tokens.length - 1].join('/') + '/'

      parent

    hasParent: (path) ->
      !!(@getParent path)

    getCurrentDir: (path) ->
      tokens = @getTokens path
      tokens[tokens.length - 1]
