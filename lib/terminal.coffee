TerminalSession = null
createTerminalSession = (state) ->
  TerminalSession ?= require './terminal-session'
  new TerminalSession(state)

atom.deserializers.add
  name: 'TerminalSession'
  version: 1
  deserialize: (state) -> createTerminalSession(state)

module.exports =
  activate: ->
    atom.project.registerOpener(@customOpener)
    atom.workspaceView.command 'terminal:open', ->
      initialDirectory = atom.project.getPath() ? '~'
      atom.workspaceView.open("terminal://#{initialDirectory}")

  deactivate: ->
    atom.project.unregisterOpener(@customOpener)

  customOpener: (uri) ->
    if match = uri?.match(/^terminal:\/\/(.*)/)
      initialDirectory = match[1]
      createTerminalSession({path: initialDirectory})
