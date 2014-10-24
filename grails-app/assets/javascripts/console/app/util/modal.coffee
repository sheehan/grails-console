App.module 'Util', (Util, App, Backbone, Marionette, $, _) ->

  Util.Modal =

    ###
    options.draggable
    options.resizable
    ###
    showInModal: (view, options = {}) ->
      $el = $('<div class="modal" data-backdrop="false"></div>').appendTo('body').html view.render().el
      $el.modal
        show: false
        keyboard: false

      $el.on 'shown.bs.modal', -> view.resize?()

      if options.draggable
        $el.find('.modal-content').draggable
          handle: '.modal-header'
          addClasses: false

        $el.find('.modal-header').css 'cursor', 'move'

      if options.resizable
        $el.find('.modal-content').resizable
          addClasses: false
          resize: (event, ui) -> view.resize?()

      $el.find('.modal-header .close').on 'click', (event) ->
        event.preventDefault()
        view.close()

      $el.find('.modal-footer .cancel').on 'click', (event) ->
        event.preventDefault()
        view.close()

      view.on 'close', ->

        $el.modal 'hide'

      $el.on 'hidden.bs.modal', ->
        $el.remove()

      $el.modal 'show'

      $el