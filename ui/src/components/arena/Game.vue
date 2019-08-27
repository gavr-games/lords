<template>
  <div id="arena-game">
    <div class="heading">
      - {{ I18n.getText('arena_game', 'game') }} -
    </div>
    <a href="#" class="red-button" @click="exitGame">{{ I18n.getText('game', 'exit') }}</a>
  </div>
</template>

<script>
  import { EventBus } from '../../lib/event_bus'
  import Errors from '../../lib/utils/errors'
  import I18n from '../../lib/utils/i18n'
  import checkUserLocation from '../../lib/concepts/user/check_location'
  
  export default {
    data() {
      return {
        I18n: I18n,
        currentGameId: null
      }
    },
    created() {
      checkUserLocation(this)
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "get_my_location":
            if (payload.data_result.game_id && payload.data_result.game_id != '') {
              this.currentGameId = payload.data_result.game_id
            }
            break;
        }
      },
      exitGame() {
        let my_id = window.localStorage.getItem('userId')
        this.$WSClient.sendLoggedProtocolCmd({
          action: 'arena_game_player_remove',
          params: {
            'game_id': this.currentGameId,
            'user_id': my_id
          }
        })
      }
    }
  }
</script>

<style lang="scss">
  #arena-game {
    .red-button {
      margin-top: 20px;
    }
  }
</style>