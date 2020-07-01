import dimscord, asyncdispatch, plugins, os, strutils
# Setup plugins first
const base = currentSourcePath.parentDir()
var manager = initPlugins(@[base / "plugins"], @[])

while manager.run != stopped:
  syncPlugins(manager)
  if manager.ready:
    echo "Plugins Loaded: " & plist(manager).join(" ")
    break

let cl = newDiscordClient("NzI3MTIwOTc4ODk4ODQ1NzIx.XvsErw.wO9TdRpz8WM1Iksuaddm1oxFSD0")
cl.debug = true

# Now setup events
cl.events.on_ready = proc (s: Shard, r: Ready) =
    echo "Connected to Discord as " & $r.user

# Event handler for new messages the bot sees
cl.events.message_create = proc (s: Shard, m: Message) =
  if m.author.bot: return
  if m.content == "!dummy":
    let cmd = newCmdData("dummy blah")
    callCommand(manager, cmd)
    discard waitFor cl.api.sendMessage(m.channel_id, cmd.returned[0])

waitFor cl.startSession()
