TerminalView = require 'terminal/lib/terminal-view'
RootView = require 'root-view'

fdescribe "Terminal view", ->
  beforeEach ->
    window.rootView = new RootView
    atom.activatePackage 'terminal'
