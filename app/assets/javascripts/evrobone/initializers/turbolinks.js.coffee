#= require turbolinks

$document = $(document)
$document.on 'page:before-unload', -> App.stop()
$document.on 'page:load page:restore', -> App.start false

# http://stackoverflow.com/questions/17690202/how-can-i-make-a-form-with-method-get-submit-with-turbolinks
$document.on 'submit', 'form[data-turboform]', ->
  Turbolinks.visit @action + (if @action.indexOf('?') is -1 then '?' else '&') + $(@).serialize()
  false
