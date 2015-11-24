Evrobone.AppMixins.WindowNavigation =

  popstateBusEventName: 'popstate'

  windowNavigationInitialize: ->
    @$window.on 'popstate', _.bind(@historyChangeHandler, @)
    return

  historyChangeHandler: ->
    @trigger @popstateBusEventName, arguments...
    return

  onPopState: (callback, context) ->
    context.listenTo @, @popstateBusEventName, callback

  offPopState: (callback, context) ->
    context.stopListening @, @popstateBusEventName, callback

  changeLocation: (url, push = false, title = '', options) ->
    #cout '!> changeLocation', url
    historyMethod = window.history[if push then 'pushState' else 'replaceState']
    if historyMethod
      unless /^\w+:\/\//.test(url)
        url = "#{window.location.protocol}//#{window.location.host}#{url}"
      historyMethod.call window.history, _.extend({ turbolinks: Turbolinks?, url: url }, options), title, url
    else
      window.location.hash = url
    return

  visit: (location) ->
    #cout '!> visit', location
    if Turbolinks?
      Turbolinks.visit location
    else
      window.location = location
    return

  reloadPage: ->
    #cout '!> reloadPage'
    @visit window.location

  refreshPage: ->
    if Turbolinks?
      $document = $(document)
      scrollTop = 0
      $document.one 'page:before-unload.refreshPage', =>
        scrollTop = @$window.scrollTop()
        return
      $document.on 'page:load.refreshPage page:restore.refreshPage', =>
        @$window.scrollTop scrollTop
        return
      Turbolinks.visit window.location
    else
      # TODO: сделать возврат scrollTop пробросом через sessionStorage
      window.location = window.location
    return
