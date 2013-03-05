Bacon  = require('baconjs').Bacon
Gaze   = require('gaze').Gaze
fs     = require 'fs'
path   = require 'path'
mkdirp = require 'mkdirp'
glob   = require 'glob'

exports.watch = watch = (pattern) ->
  gazer = new Gaze(pattern)
  gazerStream = Bacon.fromEventTarget(gazer, 'all', (event, filename) ->
    [name: filename, content: fs.readFileSync filename, 'utf8']).toProperty([])

exports.files = (pattern) ->
  watch(pattern).map ->
    glob.sync(pattern).map (filename) ->
      name: filename
      content: fs.readFileSync filename, 'utf8'

exports.write = (files) ->
  files.map (file) ->
    mkdirp.sync path.dirname(file.name)
    fs.writeFileSync file.name, file.content, 'utf8'
