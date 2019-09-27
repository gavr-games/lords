<template>
  <div id="arena-game">
    <div class="heading">
      - {{ game.title }} -
    </div>
    <div class="cols">
      <div id="features">
        <div class="feature" v-for="feature in features">
          <div v-if="feature.feature_type == 'bool'">
            {{ findCreateGameFeature(feature.feature_id).name }}
          </div>
        </div>
      </div>
    </div>
    <a href="#" class="red-button" @click="exitGame">{{ I18n.getText('game', 'exit') }}</a>
  </div>
</template>

<script>
  import { EventBus } from '../../lib/event_bus'
  import Errors from '../../lib/utils/errors'
  import I18n from '../../lib/utils/i18n'
  import checkUserLocation from '../../lib/concepts/user/check_location'
  import getMyId from '../../lib/concepts/user/get_my_id'
  
  export default {
    data() {
      return {
        I18n: I18n,
        currentGameId: null,
        game: {},
        createGameFeatures: [],
        features: [],
        players: []
      }
    },
    created() {
      checkUserLocation(this)
      EventBus.$on('arena-command', this.executeCmd)
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      EventBus.$on('received-arena-current-game-info-raw', this.handleArenaCurrentGameInfoRaw)
      this.$WSClient.sendLoggedProtocolCmd({}, "get_current_game_info")
    },
    beforeDestroy () {
      EventBus.$off('arena-command', this.executeCmd)
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
      EventBus.$off('received-arena-current-game-info-raw', this.handleArenaCurrentGameInfoRaw)
      this.$WSClient.leaveGame(this.currentGameId)
    },
    methods: {
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "get_my_location":
            if (payload.data_result.game_id && payload.data_result.game_id != '') {
              this.currentGameId = payload.data_result.game_id
              this.$WSClient.joinGame(this.currentGameId)
            }
            break;
        }
      },
      handleArenaCurrentGameInfoRaw(payload) {
        console.log(payload)
        this.game = payload.info.game[0]
        this.createGameFeatures = payload.info.create_game_features
        this.features = payload.info.features
        this.players = payload.info.players
      },
      executeCmd(payload) {
        if (this[payload.cmd] !== undefined) {
          this[payload.cmd](...payload.params)
        }
      },
      arena_game_remove_player(gameId, userId) {
        if (gameId == this.currentGameId && userId == getMyId()) {
          // do nothing
        }
      },
      exitGame() {
        this.$WSClient.sendLoggedProtocolCmd({
          action: 'arena_game_player_remove',
          params: {
            'game_id': this.currentGameId,
            'user_id': getMyId()
          }
        })
      },
      findCreateGameFeature(featureId) {
        return this.createGameFeatures.find(f => parseInt(f.id) === parseInt(featureId))
      }
    }
  }
</script>

<style lang="scss">
  #arena-game {
    .cols {
      display: flex;
      flex-direction: row;
    }
    .red-button {
      margin-top: 20px;
    }
  }
</style>