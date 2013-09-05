pty = require 'pty.js'
EventEmitter = require('events').EventEmitter

class PtyProcessContext
  constructor: (proc) ->
    @process = proc || pty.spawn process.env.SHELL, ['-l'],
      name: 'xterm-256color'
      cols: 80
      rows: 30
      cwd: process.env.ptyCwd
      env: process.env

    @process.on 'data', (data) -> this.send({type: 'data', data})
    @process.on 'exit', -> this.send(type: 'exit')

    resize: (columns, rows) ->
      @process.resize(columns, rows)

    sendInput: (text) ->
      @process.write(text)


util.inherits PtyProcessContext, EventEmitter

module.exports = PtyProcessContext
