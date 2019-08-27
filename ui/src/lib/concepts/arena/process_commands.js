import { EventBus } from '../../event_bus'

export default function (payload) {
  if (!payload.commands || payload.commands == "") {
    return
  }
  let commands = payload.commands.split(";")
  commands.forEach(function(command) {
    if (command == "") {
      return
    }
    command = command.replace(/^\(+|\)+$/g, '') //remove ")"
    let startParamsPos = command.indexOf("(")
    let commandName = command.substr(0,startParamsPos)
    let commandParams = command.substr(startParamsPos + 1, command.length).split(",")
    EventBus.$emit('arena-command', {cmd: commandName, params: commandParams})
  })
}