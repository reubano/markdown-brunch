marked = require 'marked'
hljs = require 'highlight.js'
umd = require 'umd-wrapper'
yfm = require 'yaml-front-matter'

module.exports = class MarkdownCompiler
  brunchPlugin: yes
  type: 'javascript'
  extension: 'md'
  pattern: /(\.(markdown|mdown|mkdn|md|mkd|mdwn|mdtxt|mdtext|text))$/

  constructor: (config) ->
    options = Object.create(config.marked ? null)

    # If highlight isn't defined in config then use default Highlight.js
    unless 'highlight' of options
      options.highlight = (code, lang) ->
        if lang is 'auto'
          hljs.highlightAuto(code).value
        else if hljs.getLanguage(lang)
          hljs.highlight(lang, code).value

    # Set marked options
    marked.setOptions(options)

  compile: (data, path, callback) ->
    try
      obj = yfm.loadFront data, 'md'
      obj.html = marked obj.md
      result = umd JSON.stringify obj
    catch err
      error = err
    finally
      callback error, result
