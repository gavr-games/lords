<template>
  <div id="arena-profile" v-bind:class="['profile-overlay', showProfile ? 'active' : '']">
    <div class="profile-container">
      <a href="#" class="close-profile" @click="hideProfileWindow"> </a>
      <div class="content">
        <div class="left-col">
          <div class="avatar">
            <div class="default-avatar">
            </div>
          </div>
          <div class="login">
            {{ login }}
          </div>
        </div>
        <div class="right-col">
          <div class="stats-heading">
            {{ I18n.getText('profile', 'statistics') }}
          </div>
          <div class="stats-mode" v-for="modStat in stats">
            <div class="row">
              <div class="stat-name">{{ I18n.getText('profile', 'mode') }}:</div>
              <div class="stat-value">{{ modStat.mode_name}}</div>
            </div>
            <div class="row">
              <div class="stat-name">{{ I18n.getText('profile', 'total_games') }}:</div>
              <div class="stat-value">{{ modStat.games_played}}</div>
            </div>
            <div class="row">
              <div class="stat-name">{{ I18n.getText('profile', 'victories') }}:</div>
              <div class="stat-value">{{ modStat.win}}</div>
            </div>
            <div class="row">
              <div class="stat-name">{{ I18n.getText('profile', 'defeats') }}:</div>
              <div class="stat-value">{{ modStat.lose}}</div>
            </div>
            <div class="row">
              <div class="stat-name">{{ I18n.getText('profile', 'draws') }}:</div>
              <div class="stat-value">{{ modStat.draw}}</div>
            </div>
            <div class="row">
              <div class="stat-name">{{ I18n.getText('profile', 'left_the_game') }}:</div>
              <div class="stat-value">{{ modStat.exit}}</div>
            </div>
          </div>
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
        showProfile: false,
        avatarFilename: '',
        lastPlayedGame: null,
        login: '',
        stats: [],
        I18n: I18n
      }
    },
    created() {
      EventBus.$on('show-player-profile', this.showProfileWindow)
      EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
    },
    beforeDestroy () {
      EventBus.$off('show-player-profile', this.showProfileWindow)
      EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
    },
    methods: {
      handleProtocolRaw(payload) {
        switch(payload["action"]) {
          case "get_user_profile":
            console.log(payload)
            this.lastPlayedGame = payload["data_result"][0]["last_played_game"]
            this.avatarFilename = payload["data_result"][0]["avatar_filename"]
            this.login = payload["data_result"][0]["login"]
            payload["data_result"].shift()
            this.stats = payload["data_result"]
            this.showProfile = true
            break;
        }
      },
      showProfileWindow(playerId) {
        this.$WSClient.sendLoggedProtocolCmd({
          action: 'get_user_profile',
          params: {player_id: playerId}
        });
      },
      hideProfileWindow() {
        this.showProfile = false
      }
    }
  }
</script>

<style lang="scss">
  .profile-overlay {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    transition: opacity 500ms;
    visibility: hidden;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    &.active {
      visibility: visible;
      opacity: 1;
    }
    .profile-container {
      width: 506px;
      height: 503px;
      background: center url('../../assets/profile_window_background.png') no-repeat;
      transition: all 1s ease-in-out;
        .close-profile {
          opacity: 0.5;
          display: block;
          position: relative;
          background: url('../../assets/close_button.png') no-repeat;
          width: 29px;
          height: 28px;
          left: 380px;
          top: 105px;
          &:hover {
            opacity: 1;
          }
        }
        .content {
          padding: 110px 110px 50px 100px;
          display: flex;
          flex-direction: row;
          .left-col {
            width: 120px;
            display: flex;
            flex-direction: column;
          }
          .right-col {
            height: 180px;
            overflow-y: scroll;
            flex: 1;
            display: flex;
            flex-direction: column;
          }
          .login {
            font-size: 16px;
            text-align: center;
          }
          .avatar {
            width: 120px;
            height: 120px;
            background: center url('../../assets/profile_avatar_border.png') no-repeat;
            .default-avatar {
              width: 120px;
              height: 120px;
              background: center url('../../assets/guest_user.png') no-repeat;
            }
          }
          .stats-heading {
            font-size: 14px;
            text-align: center;
          }
          .stats-mode {
            margin-left: 10px;
            margin-top: 10px;
            .row {
              display: flex;
              flex-direction: row;
              font-size: 10px;
              .stat-name {
                width: 100px;
              }
            }
          }
        }
    }
  }
</style>