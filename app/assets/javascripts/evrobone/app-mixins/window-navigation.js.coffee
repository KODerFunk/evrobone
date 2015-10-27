Evrobone.AppMixins.WindowNavigation =

  changeLocation: (url, push = false, title = '', options) ->
    #cout '!> changeLocation', url
    historyMethod = window.history[if push then 'pushState' else 'replaceState']
    if historyMethod
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
