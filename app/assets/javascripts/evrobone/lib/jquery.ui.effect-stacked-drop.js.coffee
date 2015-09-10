# jQuery UI Effects Stacked Drop   based on   jQuery UI Effects Drop 1.10.0
#= require jquery-ui/effect

# coffeelint: disable=cyclomatic_complexity
do ($ = jQuery) ->

  $.effects.effect.stackedDrop = (o, done) ->
    el = $(@)
    props = ['position', 'top', 'bottom', 'left', 'right', 'opacity', 'height', 'width']
    mode = $.effects.setMode(el, o.mode or 'hide')
    show = mode is 'show'
    direction = o.direction or 'left'
    ref = if (direction is 'up' or direction is 'down') then 'top' else 'left'
    motion = if (direction is 'up' or direction is 'left') then 'pos' else 'neg'
    animation = opacity: (if show then 1 else 0)

    # Adjust
    $.effects.save el, props
    el.show()
    $.effects.createWrapper el
    distance = o.distance or el[(if ref is 'top' then 'outerHeight' else 'outerWidth')](true) / 2
    el.css('opacity', 0).css ref, (if motion is 'pos' then -distance else distance)  if show

    # Animation
    animationValue = if show then (if motion is 'pos' then '+=' else '-=') else (if motion is 'pos' then '-=' else '+=')
    animation[ref] = animationValue + distance

    _complete = ->
      $.effects.restore el, props
      $.effects.removeWrapper el
      done()

    # Animate
    el.animate animation,
      queue: false
      duration: o.duration
      easing: o.easing
      complete: ->
        if mode is 'hide'
          el.hide()
          wrapper = el.parent('.ui-effects-wrapper')
          if wrapper.length
            wrapper.slideUp
              duration: o.duration
              easing: o.easing
              complete: _complete
        else
          _complete()
  undefined
# coffeelint: enable=cyclomatic_complexity
