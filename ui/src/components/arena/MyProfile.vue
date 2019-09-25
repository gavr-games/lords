<template>
  <div id="arena-my-profile">
    <div class="heading">
      - {{ I18n.getText('profile', 'profile') }} -
    </div>
    <a href="#" class="red-button" @click="exitArena">{{ I18n.getText('game', 'exit') }}</a>
  </div>
</template>

<script>
  import { EventBus } from '../../lib/event_bus'
  import Errors from '../../lib/utils/errors'
  import I18n from '../../lib/utils/i18n'
  
  export default {
    data() {
      return {
        I18n: I18n
      }
    },
    created() {
      //EventBus.$on('received-protocol-raw', this.handleProtocolRaw)
      //EventBus.$on('received-arena-info-raw', this.handleArenaInfoRaw)
    },
    beforeDestroy () {
      //EventBus.$off('received-protocol-raw', this.handleProtocolRaw)
      //EventBus.$off('received-arena-info-raw', this.handleArenaInfoRaw)
    },
    methods: {
      handleArenaInfoRaw(payload) {
        
      },
      exitArena() {
        this.$WSClient.sendLoggedProtocolCmd({
            action: 'arena_exit',
            params: {}
        });
      }
    }
  }
</script>

<style lang="scss">
  #arena-my-profile {

  }
</style>