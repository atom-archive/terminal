TerminalSession = require '../lib/terminal-session'
{WorkspaceView} = require 'atom'

describe "Terminal", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.packages.activatePackage 'terminal'

  describe "the terminal:open command", ->
    it "opens a terminal session for the given path in the current pane", ->
      atom.workspaceView.trigger 'terminal:open'

      waitsFor ->
        atom.workspaceView.getActivePane()

      runs ->
        expect(atom.workspaceView.getActivePaneItem() instanceof TerminalSession).toBe true
