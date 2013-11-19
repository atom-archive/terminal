TerminalSession = require '../lib/terminal-session'
{RootView} = require 'atom'

describe "Terminal", ->
  beforeEach ->
    atom.rootView = new RootView
    atom.packages.activatePackage 'terminal'

  describe "the terminal:open command", ->
    it "opens a terminal session for the given path in the current pane", ->
      atom.rootView.trigger 'terminal:open'

      waitsFor ->
        atom.rootView.getActivePane()

      runs ->
        expect(atom.rootView.getActivePaneItem() instanceof TerminalSession).toBe true
