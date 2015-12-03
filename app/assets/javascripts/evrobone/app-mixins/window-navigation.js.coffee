Evrobone.AppMixins.WindowNavigation =

  popstateBusEventName: 'popstate'
  refreshPageStorageKey: 'refreshPage:scrollTop'

  windowNavigationInitialize: ->
    if scrollTop = sessionStorage?.getItem(@refreshPageStorageKey)
      @$window.scrollTop scrollTop
      sessionStorage.removeItem @refreshPageStorageKey
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
    historyMethod = window.history[if push then 'pushState' else 'replaceState']
    if historyMethod
      unless /^\w+:\/\//.test(url)
        url = "#{window.location.protocol}//#{window.location.host}#{url}"
      historyMethod.call window.history, _.extend({ turbolinks: Turbolinks?, url: url }, options), title, url
    else
      window.location.hash = url
    return

  visit: (location) ->
    if Turbolinks?
      Turbolinks.visit location
    else
      window.location = location
    return

  reloadPage: ->
    @visit window.location

  refreshPage: ->
    if Turbolinks?
      # TODO may be should use similar mech as for non-turbo variant with sessionStorage
      $document = $(document)
      scrollTop = 0
      $document.one 'page:before-unload.refreshPage', =>
        scrollTop = @$window.scrollTop()
        return
      # TODO on or one ?
      $document.one 'page:load.refreshPage page:restore.refreshPage', =>
        @$window.scrollTop scrollTop
        return
    else
      # TODO need store url and timestamp for more strong collision protection
      sessionStorage?.setItem @refreshPageStorageKey, @$window.scrollTop()
    @reloadPage()
    return
