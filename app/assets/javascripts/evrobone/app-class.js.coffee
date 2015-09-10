#= require ./helpers
#= require ./jquery-additions

@Evrobone ||= {}

Evrobone.AppMixins ||= {}

class Evrobone.AppClass
  @App: null

  name: null
  performanceReport: true
  performanceMicro: false

  touchDevice: ('ontouchstart' of document.documentElement and not TEST_MODE)
  # or !!(window.DocumentTouch and document instanceof DocumentTouch)
  $window: null

  @mixinNames: null

  # Reset mixinNames
  @mixinable: ->
    @mixinNames = if @mixinNames then _.clone(@mixinNames) else []

  # Mixins support
  @include: (mixin, name = null) ->
    @mixinNames ||= []
    if name?
      @mixinNames = _.without(@mixinNames, name)
      @mixinNames.push(name)
    unless mixin?
      cout 'error', "AppMixin #{name or '_no_name_'} is undefined"
    _.extend @::, mixin

  @include Backbone.Events

  constructor: (name = null) ->
    if @constructor.App
      throw new Error('Can\'t create new AppClass instance because the single instance has already been created')
    else
      cout 'info', 'Evrobone.AppClass.constructor', name, @
      @constructor.App = @
      @name = name
      for mixinName in @constructor.mixinNames
        @[mixinName + 'Initialize']?()
    return

  start: (initial = true) ->
    @$window = $(window) if initial
    $('body').addClass('touch-device') if @touchDevice
    @performanceReport = DEBUG_MODE if @performanceReport
    @performanceStart() if @performanceReport
    @trigger 'start', initial
    return

  stop: ->
    @trigger 'stop'
    return

  performanceStartAt: null

  performanceStart: ->
    if _.isFunction(performance?.now)
      @performanceStartAt = performance.now()
    else
      cout 'warn', 'performance.now() isnt available'
      @performanceReport = null

  performancePoint: (message, count = null) ->
    pointAt = performance.now()
    message = @_plurMessage(message, count) if count?
    time = if @performanceMicro
      "#{Math.round((pointAt - @performanceStartAt) * 1000)}\u00B5s"
    else
      "#{Math.round(pointAt - @performanceStartAt)}ms"
    cout 'info', "#{message} in #{time}"
    @performanceStartAt = pointAt

  _plurMessage: (message, count) ->
    message.replace('%count%', count).replace('%s%', if count is 1 then '' else 's')
