import plugins/api
import strutils, httpclient

proc weather(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Specify a location. Commands available: `weather, sunrise, moon, weatherimage`"
  else:
    let client = newHttpClient(userAgent="curl")
    try:
      let weather = client.getContent("https://wttr.in/" & cmd.params.join(" ") & "?format=3")
      cmd.returned.add weather
    except:
      cmd.returned.add "Error retrieving weather"
    client.close()

proc sunrise(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Specify a location. Commands available: `weather, sunrise, moon, weatherimage`"
  else:
    let client = newHttpClient(userAgent="curl")
    try:
      let weather = client.getContent("https://wttr.in/" & cmd.params.join(" ") & "?format=%l:+%S+%s")
      cmd.returned.add weather
    except:
      cmd.returned.add "Error retrieving weather"

    client.close()

proc moon(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  let client = newHttpClient(userAgent="curl")
  try:
    var weather = client.getContent("https://wttr.in/" & cmd.params.join(" ") & "?format=%m+%M")
    weather.removeSuffix
    cmd.returned.add weather & " moon day(s)"
  except:
    cmd.returned.add "Error retrieving weather"
  client.close()

#proc weatherimage(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
#  if len(cmd.params) == 0:
#    cmd.returned.add "Specify a location. Commands available: `weather, sunrise, moon, weatherimage`"
#  else:
#    let weather = "https://wttr.in/" & cmd.params.join(" ") & "_Q0pu.png"
#    cmd.returned.add weather

pluginLoad:
  discard

pluginReady:
  discard
