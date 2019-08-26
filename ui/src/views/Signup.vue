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
            <div class="portal-input">
                <label for="repeat-pass">{{ I18n.getText('signup', 'repeat_pass') }}</label>
                <input type="password" name="repeat-pass" id="repeat-pass" v-model="repeat_pass">
            </div>
            <div class="portal-input">
                <label for="email">Email</label>
                <input type="email" name="email" id="email" v-model="email">
            </div>
            <a href="#" class="portal-link green-button" @click="doSignup">{{ I18n.getText('signup', 'do_signup') }}</a>
            <p v-bind:class="['portal-error', showError ? 'show' : '']" class="portal-error">{{ error }}</p>
            <router-link to="/" class="portal-link signup-link"><span>{{ I18n.getText('back') }}</span></router-link>
          </div>
        </div>
        <div class='column'>
          <div class="legend-column">
            <p>
              {{ I18n.getText('signup', 'email_help') }}
            </p>
            <a href="#" class="portal-link green-button" @click="showRules">{{ I18n.getText('rules', 'rules') }}</a>
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

  export default {
    data() {
      return {
        login: "",
        pass: "",
        repeat_pass: "",
        email: "",
        error: "Error",
        showError: false,
        I18n: I18n
      }
    },
    created() {
      this.$WSClient.joinChannel('base');
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw);
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      doSignup() {
        if (this.pass != this.repeat_pass) {
          this.error = I18n.getText('signup', 'pass_mismatch')
          this.showError = true
          return;
        }
        if (this.pass == "" || this.login == "" || this.repeat_pass == "") {
          this.error = I18n.getText('login', 'fields_blank')
          this.showError = true
          return;
        }
        let email = "null"
        if (this.email != "") {
          email = '"' + Chars.convertChars(this.email) + '"'
        }
        this.$WSClient.sendBaseProtocolCmd({
          action: 'user_add',
          params: {
            login: '"' + Chars.convertChars(this.login) + '"',
            pass: '"' + this.pass.replace(new RegExp('"', 'g'), '\\"') + '"',
            email: email
          }
        });
      },
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "user_add":
            if (parseInt(payload.header_result.success) == 1) {
              this.showError = false
              this.$router.push('/')
            } else {
              this.error = Errors.getMsg(payload.header_result.error_code, payload.header_result.error_params)
              this.showError = true
            }
            break;
          case "arena_enter":
            this.$router.push('arena')
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
        this.showError = false
        this.$WSClient.sendLoggedProtocolCmd({
          action: 'user_language_change',
          params: {
            language: '"' + language + '"'
          }
        });
        this.$forceUpdate()
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
      height: 240px;
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