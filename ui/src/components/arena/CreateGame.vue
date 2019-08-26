<template>
  <div id="arena-create-game">
    <div class="heading">
      - {{ I18n.getText('arena_creategame', 'create_game') }} -
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
        
      }
    }
  }
</script>

<style lang="scss">
  #arena-create-game {

  }
</style>