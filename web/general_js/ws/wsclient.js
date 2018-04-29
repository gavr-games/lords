"use strict"
import {
    Socket
} from "./phoenix.js"

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
        this.socket = new Socket("ws://" + window.location.hostname + ":4000/socket", {
            params: {
                token: Cookie.read("PHPSESSID")
            }
        })
        if (this.debug) {
            console.log('trying to connect');
        }
        this.socket.connect()
        this.connected = true
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
            let self = this
            jQuery.get("/site/ajax/get_user_session.php", function(data) {
                self.user_id = JSON.decode(data)["user_id"]
                let channelName = "user:" + self.user_id
                self.joinChannel(channelName)
                self.sendJSONtoChannel(channelName, cmd, params)
            });
        } else {
            this.sendJSONtoChannel("user:" + this.user_id, cmd, params)
        }
    }

    sendGameProtocolCmd(params) {
        this.sendLoggedProtocolCmd(params, "game_protocol_cmd")
    }

    sendPerformance(params) {
        this.sendLoggedProtocolCmd(params, "performance")
    }

    sendJSONtoChannel(channelName, cmd, params) {
        if (this.debug) {
            console.log("Send " + JSON.encode(params) + " to " + channelName)
        }
        this.channels[channelName].push(cmd, {
            json_params: JSON.encode(params)
        })
    }

    getGameInfo() {
        this.sendLoggedProtocolCmd({}, "get_game_info")
    }

    joinChannel(channelName) {
        if (!this.connected) {
            this.connect()
        }
        let channel = this.socket.channel(channelName, {})

        channel.on("new_msg", payload => {
            let chatId = channelName.split(":")[1]
            if (this.debug) {
                console.log("chat_add_user_message(" + chatId + ", " + payload.from_user_id + ", " + decodeURIComponent(payload.msg) + ")")
            }
            window.current_window.contentWindow.chat_add_user_message(chatId, payload.from_user_id, payload.time, decodeURIComponent(payload.msg))
        })

        channel.on("protocol_raw", payload => {
            this.handleProtocolRawMessage(payload)
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
            payload.commands = payload.commands.replace(/\\u0027/g, "'");
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
                if (typeOf(current_window) != 'null') {
                    current_window.fade(1);
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
            console.log(decodeURIComponent(payload.commands));
        }
        if (current_window.contentWindow.$) {
            try {
                current_window.contentWindow.eval(decodeURIComponent(payload.commands));
            } catch (e) {
                displayLordsError(e, decodeURIComponent(payload.commands) + '<br />Commands:' + current_window.contentWindow.last_executed_procedure + '<br />Last API:' + current_window.contentWindow.last_executed_api);
            }
        }
    }

    convertFromChars(s) {
        var escaped_one_to_xml_special_map = {
            '&amp;': '&',
            '&quot;': '"',
            '&lt;': '<',
            '&gt;': '>',
            '&#92;': '\\',
            '&apos;': '\'',
            '&#39;': '\''
        };
        return s.replace(/(&quot;|&lt;|&gt;|&amp;|&#92;|&apos;|&#39;)/g, function (str, item) {
            return escaped_one_to_xml_special_map[item];
        });
    }
}