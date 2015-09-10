Evrobone.AppMixins.CustomElementBinding =

  customElementBindingInitialize: ->
    @on 'start', @customElementBindingStart, @
    return

  customElementBindingStart: (initial) ->
    @bindCustomElements null, initial
    @performancePoint('Processed %count% custom element binder%s%', @customElementBinders.length) if @performanceReport
    return

  customElementBinders: []

  registerCustomElementBinder: (binder) ->
    @customElementBinders.push binder

  bindCustomElements: ($root = $('body'), initial = false) ->
    for binder in @customElementBinders
      binder arguments...
    return

  registerEasyBinder: (name, handle) ->
    if _.isArray(name)
      [name, selector] = name
    else
      selector = ".js-#{name}"
    @registerCustomElementBinder ($root, initial) ->
      $elements = $root.find("#{selector}:not(.bound-#{name})")
      $elements.addClass "bound-#{name}"
      if $elements.length
        handle $elements, initial
      return
    return
