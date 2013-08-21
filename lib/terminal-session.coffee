{fork} = require 'child_process'
fsUtils = require 'fs-utils'

EventEmitter = require 'event-emitter'
_ = require 'underscore'
guid = require 'guid'

TerminalBuffer = require './terminal-buffer'

module.exports =
class TerminalSession
  path: null
  process: null
  exitCode: null

  constructor: ({@path, @id}) ->
    @id ?= guid.create().toString()
    @buffer = new TerminalBuffer

    @process = @forkPtyProcess()
    @process.on 'message', ({type, data}) => @trigger type, data

    @on 'data', (data) => @buffer.trigger 'data', data
    @on 'input', (data) => @input(data)
    @on 'resize', (data) => @resize(data)
    @buffer.on 'update', (data) => @trigger 'update', data
    @buffer.on 'clear', => @trigger 'clear'
    @process.on 'exit', => @exitCode = 0

  forkPtyProcess: ->
    processPath = require.resolve('./terminal-process')
    bootstrap = """
      require('coffee-script');
      require('coffee-cache').setCacheDir('/tmp/atom-coffee-cache');
      require('#{processPath}');
    """
    env = _.extend({ptyCwd: fsUtils.absolute(@path)}, process.env)
    args = [bootstrap, '--harmony_collections']
    fork '--eval', args, {env, cwd: __dirname}

  serialize: ->
    deserializer: 'TerminalSession'
    path: @path
    id: @id

  getViewClass: ->
    require './terminal-view'

  getTitle: -> 'Terminal'

  getUri: -> "terminal://#{@id}#{@path}"

  destroy: ->
    @process.kill()

  input: (data) ->
    @process.send(event: 'input', text: data)

  resize: (data) ->
    [rows, columns] = data
    @buffer.setSize([rows, columns])
    @process.send({event: 'resize', rows, columns})

_.extend TerminalSession.prototype, EventEmitter
