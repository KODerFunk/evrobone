class @LiveReloadPluginRails
  @identifier = 'rails'
  @version = '1.0'

  window: null
  host: null
  document: null
  console: null

  constructor: (@window, @host) ->
    @document = @host._reloader.document
    @console = @host._reloader.console
    return

  debounced: null

  reload: (path, options) ->
    # в path бывает полный путь до руби файла или имя файла последнего звена пайплайна
    # в options.originalPath же бывает бывает полный путь до файла первого звена пайплайна
    #cout 'reload', path, options
    if /\.css_scsslint_tmp\d+\.css$/.test(path)
      true
    else if /\.css$/i.test(path)
      @reloadStylesheet(path)
    else if App?.refreshPage? and ( /\.(rb|html)$/i.test(path) or /\.haml$/i.test(options.originalPath) )
      @debounced ||= _.debounce(( -> App.refreshPage() ), 300)
      @debounced()
      true
    else
      false

  reloadStylesheet: (path) ->
    # has to be a real array, because DOMNodeList will be modified
    # coffeelint: disable=max_line_length
    links = (link for link in @document.getElementsByTagName('link') when link.rel.match(/^stylesheet$/i) and not link.__LiveReload_pendingRemoval)
    # coffeelint: enable=max_line_length
    # handle prefixfree
    if @window.StyleFix and @document.querySelectorAll
      for style in @document.querySelectorAll('style[data-href]')
        links.push style
    @console.log "!!! LiveReload found #{links.length} LINKed stylesheets"
    pathRX = new RegExp(path.replace(/\.css$/, '(\\.self)?(-[\\da-f]{32,64})?\\.css$'))
    links = (link for link in links when pathRX.test(pathFromUrl(@host._reloader.linkHref(link))))
    @console.log "!!! Detected #{links.length} LINKed stylesheets for path: #{path}"
    if links.length
      for link in links
        @host._reloader.reattachStylesheetLink(link)
      true
    else
      false



splitUrl = (url) ->
  if (index = url.indexOf('#')) >= 0
    hash = url.slice(index)
    url = url.slice(0, index)
  else
    hash = ''
  if (index = url.indexOf('?')) >= 0
    params = url.slice(index)
    url = url.slice(0, index)
  else
    params = ''
  return { url, params, hash }

pathFromUrl = (url) ->
  url = splitUrl(url).url
  if url.indexOf('file://') is 0
    path = url.replace ///^ file:// (localhost)? ///, ''
  else
    #                        http  :   // hostname  :8080  /
    path = url.replace ///^ ([^:]+ :)? // ([^:/]+) (:\d*)? / ///, '/'
  # decodeURI has special handling of stuff like semicolons, so use decodeURIComponent
  return decodeURIComponent(path)
