pty = require 'pty.js'
fsUtils = require 'fs-utils'
EventEmitter = require 'event-emitter'
_ = require 'underscore'
TerminalBuffer = require 'terminal/lib/terminal-buffer'

module.exports =
class TerminalSession
  path: null
  process: null

  registerDeserializer(this)

  @deserialize: ({path}) ->
    new TerminalSession(path)

  constructor: (@path) ->
    @buffer = new TerminalBuffer
    @process = pty.spawn(process.env.SHELL, [],
      name: 'xterm-color'
      cols: 80
      rows: 30
      cwd: fsUtils.absolute(@path)
      env: process.env
    )

    @process.on 'data', (data) => @trigger 'data', data
    @on 'data', (data) =>
      @buffer.trigger 'data'

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
