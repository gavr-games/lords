<template>
  <div id="arena-cont">
    <div id="arena-windows-wrapper">
      <div id="arena-left-window">
        <div class="arena-window-container">
          <arena-players-list></arena-players-list>
          <arena-chat></arena-chat>
        </div>
      </div>
      <div id="arena-right-window">
        <div id="arena-content-window">
          <component :is="currentContentComponent"></component>
        </div>
        <div id="arena-main-menu">
          <div class="icon newgame" @click="showCreateGame"></div>
          <div class="icon games" @click="showGamesList"></div>
          <div class="icon profile"></div>
          <div class="icon rules" @click="showRules"></div>
        </div>
      </div>
    </div>
    <ui-rules></ui-rules>
    <arena-profile></arena-profile>
  </div>
</template>

<script>
  import { EventBus } from '../lib/event_bus'
  import Errors from '../lib/utils/errors'
  import I18n from '../lib/utils/i18n'
  import redirectUser from '../lib/concepts/user/redirect'
  import checkUserLocation from '../lib/concepts/user/check_location'
  
  export default {
    data() {
      return {
        I18n: I18n,
        currentGameId: null,
        currentContentComponent: 'arena-games-list'
      }
    },
    created() {
      checkUserLocation(this)
      this.$WSClient.joinArena()
      EventBus.$on('join-channel-error', this.goToLogin)
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      this.$WSClient.sendLoggedProtocolCmd({}, "get_arena_info")
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
      EventBus.$off('join-channel-error', this.goToLogin)
    },
    methods: {
      handleProtocolRaw(payload) {
        //TODO: handle payload.commands case - commands parser
        switch(payload["action"]) {
          case "get_my_location":
            redirectUser(this, payload.data_result)
            if (payload.data_result.game_id && payload.data_result.game_id != '') {
              this.currentGameId = payload.data_result.game_id
              this.currentContentComponent = 'arena-game'
            }
            break;
        }
      },
      showMyProfile() {

      },
      showGamesList() {
        if (this.currentGameId === null) {
          this.currentContentComponent = 'arena-games-list'
        } else {
          // show error first exit game
        }
      },
      showCreateGame() {
        if (this.currentGameId === null) {
          this.currentContentComponent = 'arena-create-game'
        } else {
          // show error first exit game
        }
      },
      showRules() {
        EventBus.$emit('show-rules')
      },
      goToLogin() {
        this.$router.push('/')
      }
    }
  }
</script>

<style lang="scss">
  #arena-cont {
    width: 100%;
    min-height: 100%;
    background: url('../assets/arena_background.jpg') center;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  #arena-windows-wrapper {
    width: 1030px;
    height: 570px;
    margin-left: 10px;
    margin-top: 40px;
    display: flex;
    flex-direction: row;
  }
  #arena-left-window {
    width: 420px;
    height: 570px;
    background: url('../assets/arena_left_window_background.png') center no-repeat;
    display: flex;
    flex-direction: column;
  }
  #arena-right-window {
    width: 610px;
    height: 570px;
    background: url('../assets/arena_right_window_background.png') center no-repeat;
    display: flex;
    flex-direction: row;
  }
  #arena-content-window {
    width: 400px;
    margin-top: 70px;
    margin-bottom: 65px;
    margin-left: 60px;
  }
  #arena-main-menu {
    margin-left: auto;
    margin-top: 45px;
    width: 135px;
    .icon {
      width: 82px;
      height: 82px;
      opacity: 0.9;
      cursor: pointer;
      &:hover{
        opacity: 1;
      }
    }
    .newgame {
      background: url('../assets/arena_icon_newgame.png') center no-repeat;
    }
    .games {
      background: url('../assets/arena_icon_games.png') center no-repeat;
    }
    .profile {
      background: url('../assets/arena_icon_profile.png') center no-repeat;
    }
    .rules {
      background: url('../assets/arena_icon_rules.png') center no-repeat;
    }
  }
</style>