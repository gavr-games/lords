<template>
  <div id="arena-games-list">
    <div class="heading">
      - {{ I18n.getText('arena_gamelist', 'game_list') }} -
    </div>
    <div class="arena-list-game" v-for="game in games">
      {{ game.game_id }}
    </div>
  </div>
</template>

<script>
  import { EventBus } from '../../lib/event_bus'
  import Errors from '../../lib/utils/errors'
  import I18n from '../../lib/utils/i18n'
  
  export default {
    data() {
      return {
        games: [],
        I18n: I18n
      }
    },
    created() {
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      this.$WSClient.sendLoggedProtocolCmd({
        action: 'get_arena_games_info',
        params: {}
      });
    },
    beforeDestroy () {
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "get_arena_games_info":
            this.games = payload.data_result
            console.log(this.games)
            break;
        }
      }
    }
  }
</script>

<style lang="scss">
  #arena-games-list {

  }
</style>