@Evrobone ||= {}

delegateEventSplitter = /^(\S+)\s*(.*)$/

class Evrobone.View extends Backbone.View

  @mixinNames: null

  constructor: (options) ->
    @reflectOptions options
    super

  reflectOptions: (options = @$el.data()) ->
    @[attr] = value  for attr, value of options  when not _.isUndefined(@[attr])
    @

  # Rest mixinNames
  @mixinable: ->
    @mixinNames = if @mixinNames then _.clone(@mixinNames) else []

  # Mixins support
  @include: (mixin, name = null) ->
    @mixinNames ||= []
    if name?
      @mixinNames = _.without(@mixinNames, name)
      @mixinNames.push(name)
    unless mixin?
      cout 'error', "ViewMixin #{name or '_no_name_'} is undefined"
    _.extend @::, mixin

  mixinsEvents: (events = {}) ->
    _.reduce( @constructor.mixinNames, ( (memo, name) -> _.extend(memo, _.result(@, name + 'Events')) ), events, @ )

  mixinsInitialize: ->
    for name in @constructor.mixinNames
      @[name + 'Initialize']? arguments...
    return

  mixinsLeave: ->
    if @constructor.mixinNames
      for name in @constructor.mixinNames
        @[name + 'Leave']? arguments...
    return

  leave: ->
    @mixinsLeave()
    @stopListening()
    return

  destroy: (destroyDOM = true) =>
    App.unbindViews [@]
    @$el.remove() if destroyDOM
    return

  # TODO: see https://github.com/jashkenas/backbone/pull/3003/files
  delegateEvents: (events) ->
    return super unless App.touchDevice
    return @ unless events or events = _.result(@, 'events')
    patchedEvents = {}
    for key, method of events
      [[], eventName, selector] = key.match(delegateEventSplitter)
      patchedEvents[if eventName is 'click' then "touchend #{selector}" else key] = method
    super patchedEvents
