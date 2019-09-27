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
        <td>
          <div v-bind:class="['pass-flag', parseInt(game.pass_flag) == 1 ? 'closed' : 'open']"></div>
        </td>
        <td>
          <a href="#" class="join-game" @click="joinGame(game.game_id)"></a>
        </td>
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
        if (this[payload.cmd] !== undefined) {
          this[payload.cmd](...payload.params)
        }
      },
      arena_game_add(gameId, ownerUserId, title, passFlag, modeId) {
        title = title.replace(/^\"+|\"+$/g, '')
        let ownerName = this.$store.getters["players/getPlayer"](ownerUserId).nick
        let modeName = modes[modeId].name
        this.addGame({
          game_id: gameId,
          title: title,
          player_count: 0,
          spectator_count: 0,
          pass_flag: passFlag,
          mode_id: modeId,
          mode_name: modeName,
          owner_id: ownerUserId,
          owner_name: ownerName
        })
      },
      arena_game_set_player_spectator_count(gameId, playerCount, spectatorCount) {
        this.updateGame({game_id: gameId, player_count: playerCount, spectator_count: spectatorCount})
      },
      arena_game_inc_spectator_count(gameId) {
        let spectatorCount = this.$store.getters["games/getGame"](gameId).spectator_count
        this.updateGame({game_id: gameId, spectator_count: spectatorCount + 1})
      },
      arena_game_dec_spectator_count(gameId) {
        let spectatorCount = this.$store.getters["games/getGame"](gameId).spectator_count
        this.updateGame({game_id: gameId, spectator_count: spectatorCount - 1})
      },
      arena_game_inc_player_count(gameId) {
        let playerCount = this.$store.getters["games/getGame"](gameId).player_count
        this.updateGame({game_id: gameId, player_count: playerCount + 1})
      },
      arena_game_dec_player_count(gameId) {
        let playerCount = this.$store.getters["games/getGame"](gameId).player_count
        this.updateGame({game_id: gameId, player_count: playerCount + 1})
      },
      arena_game_set_status(gameId, statusId) {
        this.updateGame({game_id: gameId, status_id: statusId})
      },
      arena_game_delete(gameId) {
        this.removeGame(gameId)
      },
      joinGame(gameId) {
        let game = this.$store.getters["games/getGame"](gameId)
        if (parseInt(game.pass_flag) == 0) { // no password
          if (parseInt(game.status_id) == 1) { // not started game
            this.$WSClient.sendLoggedProtocolCmd({
              action: 'arena_game_enter',
              params: {
                'game_id': gameId,
                'pass': 'null'
              }
            })
          } else if (parseInt(game.status_id) == 2) { // started game
            this.$WSClient.sendLoggedProtocolCmd({
              action: 'arena_game_spectator_enter',
              params: {
                'game_id': gameId,
                'pass': 'null'
              }
            })
          }
        } else {
          // ask password
        }
      }
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

    .pass-flag {
      &.open {
        width: 20px;
        height: 20px;
        background: right url('../../assets/arena_open_game_icon.png') no-repeat;
      }
      &.closed {
        width: 14px;
        height: 18px;
        background: right url('../../assets/arena_closed_game_icon.png') no-repeat;
      }
    }

    .join-game {
      display: block;
      width: 19px;
      height: 19px;
      background: right url('../../assets/arena_join_game_icon.png') no-repeat;
    }
  }
</style>