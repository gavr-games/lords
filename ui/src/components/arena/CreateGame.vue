<template>
  <div id="arena-create-game">
    <div class="heading">
      - {{ I18n.getText('arena_creategame', 'create_game') }} -
    </div>
    <div class="input">
      <label>{{ I18n.getText('arena_creategame', 'game_name') }}*</label>
      <input type="text" class="arena-input" v-model="name"/>
    </div>
    <div class="input">
      <label>{{ I18n.getText('arena_creategame', 'mode') }}</label>
      <select v-model="modeId">
        <option v-for="mode in gameModes" v-bind:value="mode.id">
          {{ mode.name }}
        </option>
      </select>
    </div>
    <div class="input">
      <label>{{ I18n.getText('arena_creategame', 'turn_time') }}</label>
      <select v-model="turnTime">
        <option value="0">{{ I18n.getText('arena_creategame', 'no_limit') }}</option>
        <option value="60">1 {{ I18n.getText('arena_creategame', 'minute') }}.</option>
        <option value="120">2 {{ I18n.getText('arena_creategame', 'minute') }}.</option>
        <option value="180">3 {{ I18n.getText('arena_creategame', 'minute') }}.</option>
        <option value="240">4 {{ I18n.getText('arena_creategame', 'minute') }}.</option>
        <option value="300">5 {{ I18n.getText('arena_creategame', 'minute') }}.</option>
      </select>
    </div>
    <div class="input">
      <label>{{ I18n.getText('arena_creategame', 'password') }}</label>
      <input type="password" class="arena-input" v-model="password"/>
    </div>
    <div class="input">
      <label>{{ I18n.getText('arena_creategame', 'repeat_password') }}</label>
      <input type="password" class="arena-input" v-model="confirmPassword"/>
    </div>
    <a href="#" class="green-button" @click="createGame">{{ I18n.getText('arena_creategame', 'create') }}</a>
    <p v-bind:class="['error', showError ? 'show' : '']">{{ errorText }}</p>
  </div>
</template>

<script>
  import { EventBus } from '../../lib/event_bus'
  import Errors from '../../lib/utils/errors'
  import I18n from '../../lib/utils/i18n'
  import Chars from "../../lib/utils/chars"
  
  export default {
    data() {
      return {
        I18n: I18n,
        gameModes: [],
        name: '',
        modeId: null,
        turnTime: '0',
        password: '',
        confirmPassword: '',
        showError: false,
        errorText: ''
      }
    },
    created() {
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      this.$WSClient.sendLoggedProtocolCmd({
        action: 'get_create_game_modes',
        params: {}
      })
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "get_create_game_modes":
            this.gameModes = payload["data_result"]
            this.modeId = payload["data_result"][0]["id"]
            break;
        }
      },
      createGame() {
        this.showError = false
        if (this.name == "") {
          this.errorText = I18n.getText('login', 'fields_blank')
          this.showError = true
          return
        }
        if (this.password != "" && this.password != this.confirmPassword) {
          this.errorText = I18n.getText('signup', 'pass_mismatch')
          this.showError = true
          return
        }
        let pass = "null"
        if (this.password != "") {
          pass = '"' + this.password.replace(new RegExp('"', 'g'), '\\"') + '"'
        }
        this.$WSClient.sendLoggedProtocolCmd({
            action: 'arena_game_create',
            params: {
                title: '"' + Chars.convertChars(this.name) + '"',
                pass: pass,
                time_restriction: this.turnTime,
                mode: this.modeId
            }
        })
      }
    }
  }
</script>

<style lang="scss">
  #arena-create-game {
    .heading {
      margin-bottom: 30px;
    }
    .input {
      display: flex;
      flex-direction: row;
      font-size: 18px;
      label {
        color: #dae4f0;
        width: 200px; 
        text-align: right;
        margin-right: 10px;
      } 
    }
    .green-button {
      margin-top: 20px;
    }
    .error {
      color: red;
      text-align: center;
      margin: 0px;
      visibility: hidden;
      &.show {
        visibility: visible;
      }
    }
  }
</style>