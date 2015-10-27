#= require ../view

Evrobone.AppMixins.ViewsManagement =
  View: Evrobone.View

  ViewMixins: {}
  ProtoViews: {}
  Views: {}

  preventMultibind: true
  warnOnMultibind: true
  groupBindingLog: true

  viewInstances: null

  viewsManagementInitialize: ->
    @viewInstances = []
    @warnOnMultibind = DEBUG_MODE and @warnOnMultibind
    @on 'start', @viewsManagementStart, @
    @on 'stop', @viewsManagementStop, @
    return

  viewsManagementStart: (initial) ->
    boundViews = @bindViews()
    @performancePoint('Bound %count% view%s%', boundViews.length) if @performanceReport
    return

  viewsManagementStop: ->
    @unbindViews @viewInstances
    return

  bindViews: ($root = $('html'), checkRoot = true) ->
    if @groupBindingLog
      console?.groupCollapsed? 'bindViews on', $root
    allBoundViews = []
    sortedViews = _.sortBy(_.pairs(@Views), (p) -> -p[1].priority or 0)
    for [viewName, viewClass] in sortedViews when viewClass::el
      $elements = $root.find(viewClass::el)
      $elements = $root.filter(viewClass::el).add($elements) if checkRoot
      if $elements.length
        boundViews = @_bindViews($elements, viewClass, viewName)
        if boundViews.length > 0
          @_boundInfo(boundViews, viewClass, viewName) if DEBUG_MODE and viewName and viewClass.silent isnt true
          allBoundViews = allBoundViews.concat(boundViews)
    if @groupBindingLog
      console?.groupEnd?()
    allBoundViews

  _bindViews: ($elements, viewClass, viewName) ->
    view for el in $elements.get() when view = @bindView(el, viewClass, viewName)

  bindView: (element, viewClass) ->
    if @canBind(element, viewClass)
      view = new viewClass(el: element)
      @viewInstances.push view
      view

  _boundInfo: (views, viewClass, viewName) ->
    instancesInfo = 'silent instances' if viewClass.silent is 'instances'
    if views.length > 1
      cout 'info', @_plurMessage("Bound view #{viewName} %count% time%s%:", views.length), instancesInfo or views
    else
      cout 'info', "Bound view #{viewName}:", instancesInfo or views[0]
    return

  canBind: (element, viewClass) ->
    if @preventMultibind or @warnOnMultibind
      views = @getViewsOnElement(element)
      l = views.length
      if l > 0
        if @warnOnMultibind
          cout 'warn', @_plurMessage('Element already has bound %count% view%s%', l), element, viewClass, views
        not ( @preventMultibind and _.findWhere(views, constructor: viewClass) )
      else
        true
    else
      true

  unbindViews: (views, context = null) ->
    return unless views?.length > 0
    for view in views
      view.undelegateEvents()
      view.leave context
    @viewInstances = _.without(@viewInstances, views...)
    if DEBUG_MODE
      cout 'info', @_plurMessage('Unbound %count% view%s%:', views.length),
                   _.filter(views, (v) -> not v.constructor.silent)
    return

  getViewsOnElement: (element) ->
    element = if element instanceof jQuery then element[0] else element
    _.where @viewInstances, el: element

  getViewsInContainer: ($container, checkRoot = true) ->
    _.filter @viewInstances, (view) ->
      view.$el.closest($container).length > 0 and (checkRoot or view.el isnt $container[0])

  getFirstView: (viewClass) ->
    for view in @viewInstances
      if view.constructor is viewClass
        return view
    null

  getFirstChildView: (viewClass) ->
    for view in @viewInstances
      if view instanceof viewClass
        return view
    null

  getAllViews: (viewClass) ->
    _.filter(@viewInstances, (view) -> view.constructor is viewClass)
