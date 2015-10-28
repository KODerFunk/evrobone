# coffeelint: disable=cyclomatic_complexity
do ($ = jQuery) =>

  $.fn.nearestFind = (selector, extremeEdgeSelector = 'form, body') ->
    $edge = @
    $result = $edge.find(selector)
    until $result.length or $edge.is(extremeEdgeSelector)
      $edge = $edge.parent()
      $result = $edge.find(selector)
    $result

  # [showOrHide[, duration[, callback]]]
  $.fn.slideToggleByState = ->
    if @length
      if arguments.length > 0
        a = _.toArray(arguments)
        if a.shift()
          @slideDown.apply @, a
        else
          @slideUp.apply @, a
      else
        @slideToggle()
    @

  # http://css-tricks.com/snippets/jquery/mover-cursor-to-end-of-textarea/
  $.fn.focusToEnd = ->
    @each ->
      $this = $(@)
      val = $this.val()
      $this.focus().val('').val val
      return

  $.regexp ||= {}

  $.regexp.rorId ||= /(\w+)_(\d+)$/

  @ror_id = ($elementOrString) ->
    if $elementOrString instanceof jQuery
      id = $elementOrString.data('rorId')
      unless id?
        id = ror_id($elementOrString.attr('id'))
        $elementOrString.data('rorId', id)  if id?
      id
    else if _.isString($elementOrString)
      matchResult = $elementOrString.match($.regexp.rorId)
      if matchResult then parseInt(matchResult[2]) else null
    else
      null

  $.fn.rorId = (id = null, prefix = null) ->
    if arguments.length
      $element = @first()
      elementId = @attr('id')
      if not prefix? and _.isString(elementId)
        prefix = matchResult[1]  if matchResult = elementId.match($.regexp.rorId)
      @data('rorId', id)
      if prefix?
        $element.attr 'id', "#{prefix}_#{id}"
      $element
    else
      ror_id @

  $.fn.getFileName = ->
    fileName = @val()
    if matches = fileName.match(/(.+\\)?(.+)$/)
      fileName = matches[2] or fileName
    fileName

  $.fn.$each = (callback) ->
    @each (index, element) ->
      callback $(element)

  $.fn.closestScrollable = ->
    $(_.find(@.get().concat(@parents().get()), (p) -> $(p).css('overflowY') in ['auto', 'scroll']) or window)

# RESEARCH
#  $.fn.blockHide = ->
#    @each -> jQuery._data @, 'olddisplay', 'block'
#    @css 'display', 'none'
#    @

  $.getCachedScript = (url, callback) ->
    $.ajax
      type: 'GET'
      url: url
      success: callback
      dataType: 'script'
      cache: true
# coffeelint: enable=cyclomatic_complexity
