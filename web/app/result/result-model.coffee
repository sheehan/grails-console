App.module 'Result', (Result, App, Backbone, Marionette, $, _) ->
  Result.Result = Backbone.Model.extend

    isSuccess: ->
      not @get("exception") and not @get("error")

    execute: ->
      @set 'loading', true

      jqxhr = $.post App.createLink('execute'),
        autoImportDomains: App.settings.get('editor.autoImportDomains')
        code: @get('input')

      console.info 'Executing script...'

      jqxhr.done (response) =>
        @set
          loading: false
          totalTime: response.totalTime
          exception: response.exception
          result: response.result
          output: response.output
          console: response.console

        response.console?.forEach (it) =>
          entry = JSON.parse it

          if entry
            console[entry.method].apply console, entry.args
          else
            console.warn 'Failed to marshall object'

        if response.exception
          console.log "%cScript threw an exception", 'color:#ff5555'
          console.groupCollapsed response.exception.message
          console.log item for item in response.exception.stackTrace
          console.groupEnd()
        else
          console.log "≫ #{response.result}"

        console.info "Script finished in #{response.totalTime} ms."


      jqxhr.fail =>
        if jqxhr.status
          message = "Server returned #{jqxhr.status}: #{jqxhr.responseText}"
        else
          message = "Server not found."
        console.log "%c#{message}", 'color:#ff5555'
        @set
          loading: false
          error: message
