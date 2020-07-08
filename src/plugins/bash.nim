import plugins/api
import httpclient, htmlparser, xmltree, strtabs

proc bash(plugin: Plugin, cmd: CmdData) {.plugincallback.} =
  var client = newHttpClient()
  try:
    let page = client.getContent("http://bash.org/?random")
    client.close()
    let parsed = page.parseHtml()

    var quote = "No Quote Found"
    for q in parsed.findAll("p"):
      if (q.attrs.hasKey "class") and q.attrs["class"] == "qt":
        # it's a quote!
        quote = "```html\n" & q.innerText & "```"

    cmd.returned.add quote
  except:
    cmd.returned.add "Error in retrieving quote"

pluginLoad:
  discard

pluginReady:
  discard
