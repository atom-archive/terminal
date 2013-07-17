pty = require 'pty.js'

ptyProcess = pty.spawn process.env.SHELL, ['-l'],
  name: 'xterm-256color'
  cols: 80
  rows: 30
  cwd: process.env.ptyCwd
  env: process.env

ptyProcess.on 'data', (data) -> process.send(data)

process.on 'message', (message) ->
  switch message.event
    when 'resize'
      {columns, rows} = message
      ptyProcess.resize(columns, rows)
    when 'input'
      {text} = message
      ptyProcess.write(text)
