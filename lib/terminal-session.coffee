pty = require 'pty.js'
fsUtils = require 'fs-utils'
EventEmitter = require 'event-emitter'
_ = require 'underscore'
TerminalBuffer = require 'terminal/lib/terminal-buffer'

module.exports =
class TerminalSession
  path: null
  process: null
  exitCode: null

  registerDeserializer(this)

  @deserialize: ({path}) ->
    new TerminalSession(path)

  constructor: (@path) ->
    @buffer = new TerminalBuffer
    @process = pty.spawn(process.env.SHELL, ["-l"],
      name: 'xterm-256color'
      cols: 80
      rows: 30
      cwd: fsUtils.absolute(@path+"/")
      env: process.env
    )

    @process.on 'data', (data) => @trigger 'data', data
    @on 'data', (data) => @buffer.trigger 'data', data
    @on 'input', (data) => @input(data)
    @on 'resize', (data) => @resize(data)
    @buffer.on 'update', (data) => @trigger 'update', data
    @buffer.on 'clear', => @trigger 'clear'
    @process.on 'exit', =>
      @exitCode = 0
      @destroy()

  serialize: ->
    deserializer: 'TerminalSession'
    path: @path

  getViewClass: ->
    require './terminal-view'

  getTitle: ->
    "Terminal - #{@path}"

  destroy: ->
    @process.kill()

  input: (data) ->
    @process.write(data)

  resize: (data) ->
    @buffer.setSize([data[0], data[1]])
    @process.resize(data[1], data[0])

_.extend TerminalSession.prototype, EventEmitter
