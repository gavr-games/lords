"use strict"
import { Socket } from "./phoenix"
import { EventBus } from '../event_bus'

export class WSClient {
    constructor() {
        this.channels = []
        this.socket = null
        this.connected = false
        this.debug = true
        this.user_id = null
        this.game_id = null
    }
    connect() {
        let wsUrl = "wss://" + window.location.hostname + "/socket"
        this.socket = new Socket(wsUrl, {
            params: {
                token: this.getToken()
            }
        })
        if (this.debug) {
            console.log('trying to connect');
        }
        this.socket.connect()
        this.connected = true
    }
    getToken() {
      let localStorage = window.localStorage
      let token = localStorage.getItem('token')
      if (token === null) {
        token = this.generateToken()
        localStorage.setItem('token', token)
      }
      return token
    }
    generateToken() {
      return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15)
    }
    disconnect() {
        if (this.connected) {
            this.socket.disconnect()
            this.connected = false
            this.user_id = null
            if (this.debug) {
                console.log('disconnected');
            }
        }
    }

    setDebug(debug) {
        this.debug = debug
    }

    joinChat(chatId) {
        this.joinChannel("chat:" + chatId);
    }
    joinArena() {
        this.joinChannel("arena");
    }
    joinGame(gameId) {
        this.joinChannel("game:" + gameId);
    }
    joinPersonalChannel(user_id) {
        this.joinChannel("user:" + user_id);
    }
    
    sendChatMessage(chatId, msg) {
        let channelName = "chat:" + chatId
        this.channels[channelName].push("new_msg", {
            msg: msg
        })
    }

    sendGameChatMessage(gameId, msg) {
        let channelName = "game:" + gameId
        this.channels[channelName].push("new_msg", {
            msg: msg
        })
    }

    sendBaseProtocolCmd(params) {
        this.joinChannel("base");
        this.sendJSONtoChannel("base", "base_protocol_cmd", params)
    }

    sendLoggedProtocolCmd(params, cmd = "logged_protocol_cmd") {
      if (!this.user_id) {
        this.user_id = window.localStorage.getItem('userId')
        this.joinChannel("user:" + this.user_id)
      }
      this.sendJSONtoChannel("user:" + this.user_id, cmd, params)
    }

    sendGameProtocolCmd(params) {
        this.sendLoggedProtocolCmd(params, "game_protocol_cmd")
    }

    sendPerformance(params) {
        this.sendLoggedProtocolCmd(params, "performance")
    }

    sendJSONtoChannel(channelName, cmd, params) {
        if (this.debug) {
            console.log("Send " + JSON.stringify(params) + " to " + channelName)
        }
        this.channels[channelName].push(cmd, {
            json_params: JSON.stringify(params)
        })
    }

    getGameInfo() {
        this.sendLoggedProtocolCmd({}, "get_game_info")
    }

    getGameStatistic() {
        this.sendLoggedProtocolCmd({}, "get_game_statistic")
    }

    joinChannel(channelName) {
        if (!this.connected) {
            this.connect()
        }
        if (this.channels[channelName] !== undefined) {
          return
        }
        let channel = this.socket.channel(channelName, {})

        channel.on("new_msg", payload => {
            let chatId = channelName.split(":")[1]
            if (this.debug) {
                console.log("chat_add_user_message(" + chatId + ", " + payload.from_user_id + ", " + decodeURIComponent(payload.msg).replace(/\r/g, "").replace(/\n/g, "\\n") + ")")
            }
            window.current_window.contentWindow.chat_add_user_message(chatId, payload.from_user_id, payload.time, decodeURIComponent(payload.msg).replace(/\r/g, "").replace(/\n/g, "\\n"))
        })

        channel.on("protocol_raw", payload => {
            this.handleProtocolRawMessage(payload)
        })

        channel.on("arena_info_raw", payload => {
            if (this.debug) {
                console.log(payload)
            }
            EventBus.$emit('received-arena-info-raw', payload);
        })

        channel.on("game_raw", payload => {
            if (this.debug) {
                console.log(payload)
            }
            if (!recieve_cmds)
                return -1;
            if (!exec_commands_now) {
                ws_exec_cmds += decodeURIComponent(payload.commands);
                return -1;
            }
            payload.commands = decodeURIComponent(payload.commands);
            //handling ' (apostrophe) symmetric to game_protocol.php
            payload.commands = payload.commands.replace(/\\u0027/g, "'").replace(/\r/g, "").replace(/\n/g, "\\n");
            //console.log(payload.commands);
            showHint = false;
            wasError = false;
            try {
                if (DEBUG_MODE) {
                    last_commands[last_commands_i] = payload.commands;
                    last_commands_i++;
                    if (last_commands_i > 9) last_commands_i = 0;
                }
                no_backlight = true;
                commands_executing = true;
                console.log(payload.commands);
                eval(payload.commands);
                commands_executing = false;
                no_backlight = false;
                after_commands += 'last_moved_unit = 0; showHint = true;';
                if (anim_is_running) {
                    post_move_anims += after_commands;
                } else {
                    eval(after_commands);
                }
                eval(after_commands_anims);
                after_commands = '';
                after_commands_anims = '';
            } catch (e) {
                wasError = true;
                if (DEBUG_MODE) {
                    displayLordsError(e, payload.commands + after_commands + '<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
                }
            }
        })

        channel.on("game_info_raw", payload => {
            let commands = this.convertFromChars(payload.commands);
            if (this.debug) {
                console.log(payload)
            }
            try {
                eval(commands);
                recieve_cmds = true;
                initialization();
            } catch (e) {
                wasError = true;
                if (DEBUG_MODE) {
                    displayLordsError(e, commands + after_commands + '<br />Last executed_procedure:' + last_executed_procedure + '<br />Last API:' + last_executed_api);
                }
            }
        })

        channel.on("game_statistic_raw", payload => {
            let commands = this.convertFromChars(payload.commands);
            if (this.debug) {
                console.log(commands)
            }
            show_stats(commands)
        })

        channel.on("err", payload => {
            switch (payload.code.toInt()) {
                case 100:
                    break;
                case 1010:
                    setTimeout("parent.WSClient.getGameInfo();", 1000);
                    break;
                case 1004:
                    load_window("site/login.php", "left"); //authorized in another browser
                default:
                    showError(payload.code, payload.value);
            }
        })

        channel.join()
            .receive("ok", resp => {
                if (this.debug) {
                    console.log("Joined successfully " + channelName, resp)
                }
            })
            .receive("error", resp => {
                if (this.debug) {
                    console.log("Unable to join " + channelName, resp)
                }
            })

        this.channels[channelName] = channel
    }
    leaveChannel(channelName) {
        if (this.channels[channelName]) {
            this.channels[channelName].leave()
            this.channels[channelName] = null
            if (this.debug) {
                console.log("Leave channel " + channelName)
            }
        }
    }
    handleProtocolRawMessage(payload) {
        if (this.debug) {
            console.log(payload);
        }
        EventBus.$emit('received-protocol-raw', payload);
    }

    convertFromChars(s) {
        var escaped_one_to_xml_special_map = {
            '&amp;': '&',
            '&quot;': '"',
            '&lt;': '<',
            '&gt;': '>',
            '&#92;': '\\',
            '&apos;': '\'',
            '&#39;': '\'',
            '&#37;': '%'
        };
        return s.replace(/(&quot;|&lt;|&gt;|&amp;|&#92;|&apos;|&#39;|&#37;)/g, function (str, item) {
            return escaped_one_to_xml_special_map[item];
        });
    }
}