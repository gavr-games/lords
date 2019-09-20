<template>
  <div id="arena-games-list">
    <div class="heading">
      - {{ I18n.getText('arena_gamelist', 'game_list') }} -
    </div>
    <table>
      <tr>
        <th>{{ I18n.getText('arena_gamelist', 'creator') }}</th>
        <th>{{ I18n.getText('arena_gamelist', 'name') }}</th>
        <th>{{ I18n.getText('arena_gamelist', 'mode') }}</th>
        <th>{{ I18n.getText('arena_gamelist', 'players_count') }}</th>
        <th>{{ I18n.getText('arena_gamelist', 'observers_count') }}</th>
        <th></th>
        <th></th>
      </tr>
      <tr class="arena-list-game" v-for="game in games">
        <td>{{ game.owner_name }}</td>
        <td>{{ game.title }}</td>
        <td>{{ game.mode_name }}</td>
        <td>{{ game.player_count }}</td>
        <td>{{ game.spectator_count }}</td>
        <td>{{ game.pass_flag }}</td>
        <td></td>
      </tr>
    </table>
    
  </div>
</template>

<script>
  import { EventBus } from '../../lib/event_bus'
  import { mapGetters, mapState, mapActions } from 'vuex'
  import Errors from '../../lib/utils/errors'
  import I18n from '../../lib/utils/i18n'
  import {
    modes
  } from '@/lib/static_js/static_libs_portal'
  
  export default {
    computed: mapState({
      games: state => state.games.all
    }),
    data() {
      return {
        I18n: I18n
      }
    },
    created() {
      EventBus.$on('arena-command', this.executeCmd)
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      this.$WSClient.sendLoggedProtocolCmd({
        action: 'get_arena_games_info',
        params: {}
      })
    },
    beforeDestroy () {
      EventBus.$off('arena-command', this.executeCmd)
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      ...mapActions('games', [
        'addGame',
        'removeGame',
        'updateGame',
        'setGames'
      ]),
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "get_arena_games_info":
            this.setGames(payload.data_result)
            break;
        }
      },
      executeCmd(payload) {
        let gameId = null
        let ownerUserId = null
        let title = null
        let passFlag = null
        let modeId = null
        let modeName = ''
        let ownerName = ''
        let spectatorCount = 0
        let playerCount = 0
        switch(payload.cmd) {
          case "arena_game_add": //game_id, owner_user_id, title, pass_flag, mode_id
            gameId = payload.params[0]
            ownerUserId = payload.params[1]
            title = payload.params[2].replace(/^\"+|\"+$/g, '')
            passFlag = payload.params[3]
            modeId = payload.params[4]
            ownerName = this.$store.getters["players/getPlayer"](ownerUserId).nick
            modeName = modes[modeId].name
            this.addGame({
              title: title,
              player_count: playerCount,
              spectator_count: spectatorCount,
              pass_flag: passFlag,
              mode_id: modeId,
              mode_name: modeName,
              owner_id: ownerUserId,
              owner_name: ownerName
            })
            break;
          case "arena_game_set_player_spectator_count":
            gameId = payload.params[0]
            playerCount = payload.params[1]
            spectatorCount = payload.params[2]
            this.updatePlayer({game_id: gameId, player_count: playerCount, spectator_count: spectatorCount})
            break;
        }
      },
    }
  }
</script>

<style lang="scss">
  #arena-games-list {
    table {
      margin-top: 20px;
      color: rgb(218, 228, 240);
      font-size: 14px;
      th, td {
        border-bottom: 2px solid rgba($color: #ffffff, $alpha: 0.1);
      }
      th {
        font-size: 11px;
      }
      td {
        border-right: 2px solid rgba($color: #ffffff, $alpha: 0.1);
      }
    }
  }
</style>