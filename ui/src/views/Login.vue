<template>
  <ui-cards-pile>
    <ui-two-pages>
      <div class='row login-row'>
        <div class='column'>
          <div class="forms-column">
            <div class="portal-input">
                <label for="login">{{ I18n.getText('login', 'login') }}</label>
                <input type="text" name="login" id="login" v-model="login">
            </div>
            <div class="portal-input">
                <label for="pass">{{ I18n.getText('login', 'password') }}</label>
                <input type="password" name="pass" id="pass" v-model="pass">
            </div>
            <a href="#" class="portal-link monogram" @click="doLogin"><span>{{ I18n.getText('login', 'enter') }}</span></a>
            <p v-bind:class="['portal-error', showLoginError ? 'show' : '']" class="portal-error">{{ loginError }}</p>
            <div class="portal-input guest-input">
                <label for="name">{{ I18n.getText('login', 'name') }}</label>
                <input type="text" name="name" id="name" v-model="name">
            </div>
            <a href="#" class="portal-link monogram" @click="doGuestLogin"><span>{{ I18n.getText('login', 'guest_enter') }}</span></a>
            <p v-bind:class="['portal-error', showGuestLoginError ? 'show' : '']" class="portal-error">{{ guestLoginError }}</p>
            <router-link to="signup" class="portal-link signup-link"><span>{{ I18n.getText('login', 'want_signup') }}</span></router-link>
          </div>
        </div>
        <div class='column'>
          <div class="legend-column">
            <p>
              {{ I18n.getText('login', 'guest_help') }}
            </p>
            <a href="#" class="portal-link monogram" @click="showRules"><span>{{ I18n.getText('rules', 'rules') }}</span></a>
            <div class="user-language">
              <a href="#" class="portal-link line" @click="setEn"><span>En</span></a>|<a href="#" class="portal-link line" @click="setRu"><span>Ru</span></a>
            </div>
          </div>
        </div>
      </div>
    </ui-two-pages>
    <ui-rules></ui-rules>
  </ui-cards-pile>
</template>

<script>
  import Chars from "../lib/utils/chars"
  import { EventBus } from '../lib/event_bus'
  import Errors from '../lib/utils/errors'
  import I18n from '../lib/utils/i18n'
  import authenticateUser from '../lib/concepts/user/authenticate'
  import redirectUser from '../lib/concepts/user/redirect'
  import checkUserLocation from '../lib/concepts/user/check_location'
  
  export default {
    data() {
      return {
        login: "",
        pass: "",
        name: "",
        loginError: "Error",
        guestLoginError: "Error",
        showLoginError: false,
        showGuestLoginError: false,
        I18n: I18n
      }
    },
    created() {
      this.$WSClient.joinChannel('base')
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      checkUserLocation(this)
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      doLogin() {
        this.$WSClient.sendBaseProtocolCmd({
          action: 'user_authorize',
          params: {
            login: '"' + Chars.convertChars(this.login) + '"',
            pass: '"' + this.pass.replace(new RegExp('"', 'g'), '\\"') + '"'
          }
        });
      },
      doGuestLogin() {
        this.$WSClient.sendBaseProtocolCmd({
          action: 'guest_user_authorize',
          params: {
            name: '"' + Chars.convertChars(this.name) + '"'
          }
        });
      },
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "user_authorize":
            if (parseInt(payload.header_result.success) == 1) {
              this.handleSuccesfullLogin(payload)
            } else {
              this.loginError = Errors.getMsg(payload.header_result.error_code, payload.header_result.error_params)
              this.showLoginError = true
            }
            break;
          case "guest_user_authorize":
            if (parseInt(payload.header_result.success) == 1) {
              this.handleSuccesfullLogin(payload)
            } else {
              this.guestLoginError = Errors.getMsg(payload.header_result.error_code, payload.header_result.error_params)
              this.showGuestLoginError = true
            }
            break;
          case "arena_enter":
            this.$router.push('arena')
            break;
          case "get_my_location":
            console.log(payload.data_result)
            redirectUser(this, payload.data_result)
            break;
        }
      },
      setEn() {
        this.setLang(1)
      },
      setRu() {
        this.setLang(2)
      },
      setLang(language) {
        I18n.setUserLanguage(language)
        this.showLoginError = false
        this.showGuestLoginError = false
        this.$forceUpdate()
      },
      handleSuccesfullLogin(payload) {
        this.showLoginError = false
        this.showGuestLoginError = false
        authenticateUser(this, payload.data_result)
        redirectUser(this, payload.data_result)
      },
      showRules() {
        EventBus.$emit('show-rules');
      }
    }
  }
</script>

<style lang="scss">
  .legend-column {
    padding-left: 70px;
    p {
      margin-top: 10px;
      margin-left: 10px;
      height: 260px;
      overflow: hidden;
    }
    .user-language {
      margin-top: 20px;
      text-align: right;
    }
  }
  .forms-column {
    padding-top: 10px;
    padding-right: 55px;
    .guest-input {
      margin-top: 30px;
    }
    .signup-link {
      margin-top: 30px;
    }
  }
</style>