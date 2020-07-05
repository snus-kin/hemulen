import plugins/api
import strutils, httpclient

proc weather(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Specify a location. Commands available: `weather, sunrise, moon`"
  else:
    let client = newHttpClient(userAgent="curl")
    let weather = client.getContent("https://wttr.in/" & cmd.params.join(" ") & "?format=3")
    client.close()
    cmd.returned.add weather

proc sunrise(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Specify a location. Commands available: `weather, sunrise, moon`"
  else:
    let client = newHttpClient(userAgent="curl")
    let weather = client.getContent("https://wttr.in/" & cmd.params.join(" ") & "?format=%l:+%S+%s")
    client.close()
    cmd.returned.add weather

proc moon(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Specify a location. Commands available: `weather, sunrise, moon`"
  else:
    let client = newHttpClient(userAgent="curl")
    var weather = client.getContent("https://wttr.in/" & cmd.params.join(" ") & "?format=%l:+%m+%M")
    client.close()
    weather.removeSuffix
    cmd.returned.add weather & " moon day(s)"


pluginLoad:
  discard

pluginReady:
  discard
