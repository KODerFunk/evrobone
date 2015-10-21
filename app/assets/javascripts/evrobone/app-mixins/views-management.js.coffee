#= require ../view

Evrobone.AppMixins.ViewsManagement =
  View: Evrobone.View

  ViewMixins: {}
  ProtoViews: {}
  Views: {}

  warnOnMultibind: true
  preventMultibind: true
  groupBindingLog: true

  viewInstances: null

  viewsManagementInitialize: ->
    @viewInstances = []
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
    boundViews = []
    sortedViews = _.sortBy(_.pairs(@Views), (p) -> -p[1].priority or 0)
    for [viewName, viewClass] in sortedViews when viewClass::el
      if checkRoot
        @_bindViews boundViews, $root.filter(viewClass::el), viewClass, viewName
      @_bindViews boundViews, $root.find(viewClass::el), viewClass, viewName
    if @groupBindingLog
      console?.groupEnd?()
    boundViews

  _bindViews: (boundViews, $elements, viewClass, viewName) ->
    $elements.each (index, el) =>
      if view = @bindView(el, viewClass, viewName)
        boundViews.push view
    return

  bindView: (element, viewClass, viewName) ->
    if @canBind(element, viewClass)
      view = new viewClass(el: element)
      if viewName and not viewClass.silent
        cout 'info', "Bound view #{viewName}:", view
      @viewInstances.push view
      view

  canBind: (element, viewClass) ->
    if @warnOnMultibind or @preventMultibind
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
    cout 'info', @_plurMessage('Unbound %count% view%s%:', views.length), views
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
