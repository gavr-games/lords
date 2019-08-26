<template>
  <div id="arena-players-list-cont">
    <div class="heading">
      - {{ I18n.getText('arena_chat', 'arena') }} -
    </div>
    <div id="arena-players-list-search"></div>
      <div id="arena-players-list-th">
        <div class="level">
          {{ I18n.getText('arena_players', 'level') }}
        </div>
        <div class="nickname">
          {{ I18n.getText('arena_players', 'nickname') }}
        </div>
      </div>
    <div id="arena-players-list">
      <div class="arena-player" v-for="player in players">
        <div class="level">
          1
        </div>
        <div class="nickname" @click="showPlayerProfile(player.user_id)">
          {{ player.nick }}
        </div>
        <div class="status">
          {{ player.status_id }}
        </div>
      </div>
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
        players: [],
        I18n: I18n
      }
    },
    created() {
      //EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      EventBus.$on('received-arena-info-raw', this.handleArenaInfoRaw)
    },
    beforeDestroy () {
      //EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
      EventBus.$off('received-arena-info-raw', this.handleArenaInfoRaw)
    },
    methods: {
      handleArenaInfoRaw(payload) {
        this.players = payload.info.players
      },
      showPlayerProfile(playerId) {
        EventBus.$emit('show-player-profile', playerId)
      },
    }
  }
</script>

<style lang="scss">
  #arena-players-list-cont {
    background: 55px 50px url('../../assets/playerlist_vertical_line.png') no-repeat;
  }
  #arena-players-list {
    height: 254px;
    overflow-y: scroll;
    overflow-x: hidden;
    margin-bottom: 8px;
  }
  #arena-players-list-search {
    margin-top: 7px;
    height: 18px;
    background: right url('../../assets/playerlist_search_background.png') no-repeat;
  }
  #arena-players-list-th {
    height: 20px;
    display: flex;
    color: white;
    font-size: 10px;
    line-height: 20px;
    border-bottom: 2px solid rgba($color: #ffffff, $alpha: 0.1);
    padding-bottom: 5px;
    .level {
      padding-top: 5px;
      padding-bottom: 5px;
      flex: 2;
      text-align: center;
    }
    .nickname {
      padding-top: 5px;
      padding-bottom: 5px;
      padding-left: 20px;
      flex: 9;
    }
  }
  .arena-player {
    color: white;
    display: flex;
    font-size: 10px;
    line-height: 20px;
    border-bottom: 2px solid rgba($color: #ffffff, $alpha: 0.1);
    .level {
      padding-top: 5px;
      padding-bottom: 5px;
      flex: 2;
      text-align: center;
    }
    .nickname {
      cursor: pointer;
      padding-top: 5px;
      padding-bottom: 5px;
      padding-left: 20px;
      flex: 8;
    }
    .status {
      flex: 1;
    }
  }
</style>