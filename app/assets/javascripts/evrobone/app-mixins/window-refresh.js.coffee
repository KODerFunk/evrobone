Evrobone.AppMixins.WindowRefresh =

  windowRefreshEvents: ['DOMContentLoaded', 'load', 'scroll', 'resize', 'orientationchange', 'touchmove']
  windowRefreshBound: false

  _bindRefresh: ($scrollable, name) ->
    @windowRefreshBound = true
    events = _.map(@windowRefreshEvents, (e) -> "#{e}.#{name}-refresh").join(' ')
    $scrollable.on events, => @trigger "#{name}Refresh", $scrollable.scrollTop(), $scrollable
    return

  onWindowRefresh: (callback, context) ->
    @_bindRefresh(@$window, 'window') unless @windowRefreshBound
    context.listenTo @, 'windowRefresh', callback

  offWindowRefresh: (callback, context) ->
    context.stopListening @, 'windowRefresh', callback
