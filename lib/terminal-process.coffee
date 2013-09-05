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

    this.on 'message', (message) ->
      switch message.event
        when 'resize'
          {columns, rows} = message
          ptyProcess.resize(columns, rows)
        when 'input'
          {text} = message
          ptyProcess.write(text)

util.inherits PtyProcessContext, EventEmitter

module.exports = PtyProcessContext
