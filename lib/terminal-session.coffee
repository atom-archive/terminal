pty = require 'pty.js'
fsUtils = require 'fs-utils'
EventEmitter = require 'event-emitter'
_ = require 'underscore'

module.exports =
class TerminalSession
  path: null
  process: null

  registerDeserializer(this)

  @deserialize: ({path}) ->
    new TerminalSession(path)

  constructor: (@path) ->
    @process = pty.spawn(process.env.SHELL, [],
      name: 'xterm-color'
      cols: 80
      rows: 30
      cwd: fsUtils.absolute(@path)
      env: process.env
    )

    @process.on 'data', (data) => @trigger 'data', data

  serialize: ->
    deserializer: 'TerminalSession'
    path: @path

  getViewClass: ->
    require './terminal-view'

  getTitle: ->
    "Terminal - #{@path}"

  destroy: ->
    @process.kill()

_.extend TerminalSession.prototype, EventEmitter
