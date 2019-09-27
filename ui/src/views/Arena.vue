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
          <div v-bind:class="['icon', 'newgame', currentGameId === null ? '' : 'active']" @click="showCreateGame"></div>
          <div class="icon games" @click="showGamesList"></div>
          <div class="icon profile" @click="showMyProfile"></div>
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
  import getMyId from '../lib/concepts/user/get_my_id'
  import logout from '../lib/concepts/user/logout'
  import processCommands from '../lib/concepts/arena/process_commands'
  
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
      EventBus.$on('arena-command', this.executeCmd)
      EventBus.$on('join-channel-error', this.goToLogin)
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      this.$WSClient.sendLoggedProtocolCmd({}, "get_arena_info")
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
      EventBus.$off('join-channel-error', this.goToLogin)
      EventBus.$off('arena-command', this.executeCmd)
    },
    methods: {
      handleProtocolRaw(payload) {
        processCommands(payload)
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
      executeCmd(payload) {
        if (this[payload.cmd] !== undefined) {
          this[payload.cmd](...payload.params)
        }
        let gameId = null
        let userId = null
        switch(payload.cmd) {
          case "arena_game_add_player":
            gameId = payload.params[0]
            userId = payload.params[1]
            if (userId == getMyId()) {
              this.currentGameId = payload.params[0]
              this.currentContentComponent = 'arena-game'
            }
            break;
          case "arena_player_remove":
            userId = payload.params[0]
            if (userId == getMyId()) {
              this.goToLogin()
            }
            break;
          case "arena_game_delete":
            gameId = payload.params[0]
            if (this.currentGameId == gameId) {
              this.currentGameId = null
              this.showGamesList()
            }
            break;
        }
      },
      arena_game_remove_player(gameId, userId) {
        if (gameId == this.currentGameId && userId == getMyId()) {
          this.currentGameId = null
          this.showGamesList()
        }
      },
      showMyProfile() {
        this.currentContentComponent = 'arena-my-profile'
      },
      showGamesList() {
        this.currentContentComponent = 'arena-games-list'
      },
      showCreateGame() {
        if (this.currentGameId === null) {
          this.currentContentComponent = 'arena-create-game'
        } else {
          this.currentContentComponent = 'arena-game'
        }
      },
      showRules() {
        EventBus.$emit('show-rules')
      },
      goToLogin() {
        logout(this)
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
      &.active {
        background: url('../assets/arena_icon_newgame.png') center no-repeat, radial-gradient(50% 50%, white, rgba(255,0,0,0));
      }
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