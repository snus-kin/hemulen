import plugins/api

proc dummy(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  cmd.returned.add "dummytest: " & cmd.params[0]

pluginLoad:
  echo "Loaded dummy plugin"

pluginReady:
  echo "Dummy ready"
