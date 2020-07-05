# https://bible-api.com/
import plugins/api
import strutils, httpclient, json

proc bible(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  if len(cmd.params) == 0:
    cmd.returned.add "Usage: https://bible-api.com/BOOK+CHAPTER:VERSE"
  else:
    let client = newHttpClient()
    try:
      let resp = client.getContent("https://bible-api.com/" & cmd.params.join("+")).parseJson
      echo "https://bible-api.com/" & cmd.params.join("%20") & "?translation=kjv"
      client.close()

      let text = "> " & resp["text"].getStr
      cmd.returned.add text
    except HttpRequestError:
      cmd.returned.add "Usage: https://bible-api.com/BOOK+CHAPTER:VERSE"
    except JsonParsingError:
      cmd.returned.add "Server returned malformed response"

pluginLoad:
  discard

pluginReady:
  discard
