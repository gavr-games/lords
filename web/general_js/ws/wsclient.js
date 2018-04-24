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
    sendBaseProtocolCmd(params) {
        this.joinChannel("base");
        this.sendJSONtoChannel("base", "base_protocol_cmd", params)
    }

    sendLoggedProtocolCmd(params) {
        if (!this.user_id) {
            let self = this
            jQuery.get("/site/ajax/get_user_session.php", function(data) {
                self.user_id = JSON.decode(data)["user_id"]
                let channelName = "user:" + self.user_id
                self.joinChannel(channelName)
                self.sendJSONtoChannel(channelName, "logged_protocol_cmd", params)
            });
        } else {
            this.sendJSONtoChannel("user:" + this.user_id, "logged_protocol_cmd", params)
        }
    }

    sendJSONtoChannel(channelName, cmd, params) {
        if (this.debug) {
            console.log("Send " + JSON.encode(params) + " to " + channelName)
        }
        this.channels[channelName].push(cmd, {json_params: JSON.encode(params)})
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

        channel.on("err", payload => {
            switch (payload.code.toInt()) {
                case 100:
                break;
                case 1010:
                setTimeout("apeGetGameInfo();",1000);
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
        if (current_window.contentWindow.$) {
            if (this.debug) {
                console.log(decodeURIComponent(payload.commands));
            }
            try {
                current_window.contentWindow.eval(decodeURIComponent(payload.commands));
            } catch (e) {
                displayLordsError(e, decodeURIComponent(payload.commands) + '<br />Commands:' + current_window.contentWindow.last_executed_procedure + '<br />Last API:' + current_window.contentWindow.last_executed_api);
            }
        }
    }
}