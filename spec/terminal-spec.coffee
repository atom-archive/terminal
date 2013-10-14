TerminalSession = require '../lib/terminal-session'
{RootView} = require 'atom'

describe "Terminal", ->
  beforeEach ->
    window.rootView = new RootView
    atom.activatePackage 'terminal'

  describe "the terminal:open command", ->
    it "opens a terminal session for the given path in the current pane", ->
      rootView.trigger 'terminal:open'

      waitsFor ->
        rootView.getActivePane()

      runs ->
        expect(rootView.getActivePaneItem().constructor.name is 'TerminalSession').toBeTruthy()
