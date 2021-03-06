# https://bible-api.com/
import plugins/api
import strutils, httpclient, json

proc bible(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Usage: book chapter:verse"
  else:
    try:
      let client = newHttpClient()
      let resp = client.getContent("https://bible-api.com/" & cmd.params.join("+") & "?translation=kjv").parseJson
      client.close()
      let text = ">>> " & resp["text"].getStr
      cmd.returned.add text
    except HttpRequestError:
      cmd.returned.add "Usage: book chapter:verse"
    except JsonParsingError:
      cmd.returned.add "Server returned malformed response"

pluginLoad:
  discard

pluginReady:
  discard
